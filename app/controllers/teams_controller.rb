class TeamsController < ApplicationController
  before_action :is_freelancer, except: [:show]
  before_action :is_team_admin, only: [:edit,:update,:destroy,:remove]
  def index
    @teams = Team.all
  end
  def show
    @team = Team.find(params[:id])
  end

  def new
    @team = Team.new
  end

  def create
    freelancer = current_account.accountable if current_account.freelancer?

    if freelancer
        team_data = team_params
        team = Team.new(name:team_data["name"],description:team_data["description"],admin:freelancer)
        team.image.attach(team_data["image"])

        if team.save
          freelancer.teams<<team
          if freelancer.save
            redirect_to team_path(team)
          else
            render :new ,status: :unprocessable_entity ,error:"Unknowm Process"
          end
        else
          render :new ,status: :unprocessable_entity ,error:"Unknowm Process"
        end
    else
        render :new ,status: :unprocessable_entity ,error:"Unknowm Process"
    end

  end

  def  edit
    @team = Team.find(params[:id])
  end

  def update
    @team = Team.find(params[:id])
    if @team.update(team_params)
        @team.save
        redirect_to team_path(@team)
    else
      render :new ,status: :unprocessable_entity
    end
  end

  def destroy
    @team = Team.find(params[:id])
    @team.destroy
    redirect_to teams_path ,status: :see_other
  end

  def join
    @freelancer = current_account.accountable if current_account.freelancer?
    if @freelancer
    @team = Team.find(params[:team_id])

    if @freelancer and @team
      @freelancer.teams<<@team
      @freelancer.save
      @team.save
      redirect_to team_path(@team)
    end
  end
  end

  def remove
    @freelancer = Freelancer.find(params[:freelancer_id])
    @team=Team.find(params[:id])
    @freelancer.teams.delete(@team)
    @freelancer.save
    @team.save
    redirect_to teams_path(@team)
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
      redirect_to teams_path(team)
    end
  end

  def is_freelancer
    unless account_signed_in? and current_account.freelancer?

      flash[:error] = "Unauthorized action"
      if account_signed_in?
        redirect_to root_path
      else
        flash[:error] = "Unauthorized action"
        redirect_to new_account_session_path
      end
    end
  end

end

