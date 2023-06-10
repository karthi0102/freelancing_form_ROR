class TeamsController < ApplicationController

  def show
    @team = Team.find(params[:id])
  end

  def new
    @team = Team.new
  end

  def create
    @account = Account.last
    @team_data = team_params
    puts @team_data
    image = @team_data["image"]
    @team_data.delete("image")
    if @account.account_type=="freelancer"
      @team = Team.new(@team_data)
      @team.image.attach(image)
      @team_admin = TeamAdmin.new();
      @team.team_admin=@team_admin
      @account.team_admins<<@team_admin
      @team_admin.save
      @team.save
      @account.teams<<@team
      @account.save

    end
    redirect_to profile_path(@account)
  end
  private

  def team_params
    params.require(:team).permit(:name,:description,:image)
  end
end

