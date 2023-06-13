class TeamsController < ApplicationController
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
    @freelancer = Freelancer.first
    @team_data = team_params
    puts @team_data
    image = @team_data["image"]
    @team_data.delete("image")
    if @freelancer
      @team = Team.new(@team_data)
      @team.image.attach(image)
      @team_admin = TeamAdmin.new();
      @team.team_admin=@team_admin
      @freelancer.team_admins<<@team_admin
      @freelancer.teams<<@team
      @team_admin.save
      @team.save
      @freelancer.save
      redirect_to team_path(@team)
    else
      render :new ,status: :unprocessable_entity
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
    @freelancer = Freelancer.last
    @team = Team.find(params[:team_id])

    if @freelancer and @team
      @freelancer.teams<<@team
      @freelancer.save
      @team.save
      redirect_to team_path(@team)
    end
  end

  def remove
    @freelancer = Freelancer.find(params[:freelancer_id])
    @team=Team.find(params[:team_id])
    @freelancer.teams.delete(@team)
    @freelancer.save
    @team.save
    redirect_to teams_path(@team)
  end

  private

  def team_params
    params.require(:team).permit(:name,:description,:image)
  end
end

