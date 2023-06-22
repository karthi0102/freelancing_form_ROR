class Api::TeamsController < Api::ApiController
  before_action :is_freelancer, except: [:show]
  before_action :is_team_admin, only: [:edit,:update,:destroy,:remove]

  def index
    teams = Team.all
    if teams.empty?
      render json: {message:"No teams found"} ,status: :no_content
    else
      render json: teams,status: :ok
    end
  end

  def create
    freelancer = current_account.accountable if current_account.freelancer?

    team_data = team_params
    image= team_data["image"]
    team_data.delete("image")
    team_data["admin"]=freelancer
    team = Team.new(team_data)
    team.image.attach(image)


    if team.save
      freelancer.teams<<team
      if freelancer.save
        render json: {message:"Team Created",team:team},status: :created
      else
        team.destroy
        render json: {message:"Error in proccess try again"},status: :expectation_failed
      end
    else
        render json:{message:"Not Created",error:team.errors},status: :unprocessable_entity
    end

  end


  def update
    team = Team.find_by(id: params[:id])
    if team.update(team_params)
        team.save
        render json: {message:"Updated",team:team},status: :ok
    else
      render json: {message:"Error",error:team.errors},status: :unprocessable_entity
    end
  end

  def destroy
    team = Team.find_by(id: params[:id])
    if team and team.destroy
      render json: {message:"Deleted team"},status: :see_other
    else
      render json: {message:"Error"},status: :unprocessable_entity
    end

  end

  def join
    freelancer = current_account.accountable if current_account.freelancer?

    if freelancer
      team = Team.find_by(id: params[:id])
      if team
        freelancer.teams<<team
        if freelancer.save and team.save
            render json:{message:"Joined Team"},status: :ok
        else
          render json:{message:"Cannot join team"},status: :expectation_failed
        end
      else
        render json: {message:"Team not found"},status: :not_found
      end
    else
      render json: {message:"Account not found"},status: :not_found
    end
  end

  def remove
    team=Team.find_by(id: params[:id])
    freelancer = team.freelancers.find_by(id: params[:freelancer_id])
    if freelancer and team
      if freelancer.teams.delete(team)
        freelancer.save
        team.save
        render json:{message:"Removed freelancer from team "},status: :see_other
      else
        render json:{message:"Error while removing freelancer from team"},status: :expectation_failed
      end
    else
      render json:{message:"Details not Found"},status: :not_found
    end

  end

  private

  def team_params
    params.require(:team).permit(:name,:description,:image)
  end

  def is_team_admin
    team_id =  params[:id]
    team = Team.find_by(id: team_id)
    unless team and team.admin == current_account.accountable
      render json:{message:"Unauthorized"},status: :unauthorized
    end
  end

  def is_freelancer
    unless current_account and  current_account.freelancer?
      render json:{message:"Unauthorized action"},status: :unauthorized
    end
  end
  
end

