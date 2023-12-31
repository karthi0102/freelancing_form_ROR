class TeamsController < ApplicationController
  before_action :authenticate_account!
  include FreelancerAction

  before_action :is_freelancer, except: [:show]
  before_action :is_team_admin, only: [:edit,:update,:destroy,:remove]

  def index
    @teams = Team.all
  end

  def show
    if Team.exists? :id => params[:id]
      @team = Team.find_by(id: params[:id])
    else
      redirect_to root_path ,error:"Not found"
    end
  end


  def new
    @team = Team.new
  end

  def create
    @freelancer = current_account.accountable if current_account.freelancer?
    team_data = team_params
    image= team_data["image"]
    team_data.delete("image")
    team_data["admin"]=@freelancer
    @team = Team.new(team_data)
    @team.image.attach(image)

    if @team.save

      @freelancer.teams<<@team
      if @freelancer.save
        flash[:notice]="Created New Team"
        redirect_to team_path(@team)
      else
        @team.destroy
        render :new ,status: :unprocessable_entity
      end
    else
        render :new ,status: :unprocessable_entity
    end

  end

  def  edit
    @team = Team.find(params[:id])
  end

  def update
    if Team.exists? :id => params[:id]
      @team= Team.find_by(id: params[:id])
      if @team.update(team_params)
          redirect_to team_path(@team)
      else
        render :new ,status: :unprocessable_entity
      end
    else
      redirect_to root_path ,error:"Team not found"
    end
  end

  def destroy

    if Team.exists? :id => params[:id]
      team = Team.find_by(id: params[:id])
      if team.destroy
        redirect_to teams_path ,status: :see_other
      else
        redirect_to root_path,error:"cant delete team"
      end
    else
      redirect_to root_path ,error:"Team not found"
    end
  end

  def join
    freelancer = current_account.accountable if current_account.freelancer?
    if freelancer
      team = Team.find(params[:team_id])
      if team and team.freelancers.where(id:freelancer.id).length==0
        freelancer.teams<<team
        if freelancer.save and team.save
          redirect_to team_path(team),notice:"Joined in a team"
        else
          redirect_to team_path(team),error:"Error while joining a team"
        end
      else
          redirect_to teams_path,error:"Team not found"
      end
    else
      redirect_to root_path,error:"user not found"
    end
  end


  def remove
    if Team.exists? :id =>params[:id]
        team=Team.find_by(id: params[:id])
        freelancer = Freelancer.find_by(id:params[:freelancer_id])
        if freelancer
          freelancer.teams.delete(team)
            if freelancer.save and team.save
              redirect_to team_path(team),notice:"Removed from team"
            else
              redirect_to root_path ,error:"Error while removing"
            end
        else
          redirect_to root_path,error:"Freelancer not found"
        end
    else
      redirect_to teams_path,error:"Team not found"
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
      flash[:error]="Unauthorized action"
      redirect_to root_path
    end
  end



end

