class FeedbackController < ApplicationController
  
  def new
    @feedback=Feedback.new
    @to=params[:to].to_i
    @from=params[:from].to_i
    @member_id = params[:member_id].to_i
  end

  def team
    @feedback=Feedback.new
    @to=params[:to].to_i
    @from=params[:from].to_i
    @member_id=params[:from].to_i
  end
  def team_create
    @feedback_data = feedback_params
    @team = Team.find(@feedback_data["to"])
    @Account = Account.find(@feedback_data["from"])
    @team.freelancers.each do |member|
      @feedback = Feedback.new(created:@client.id,recipient:member.account,rating:@feedback_data["rating"],comment:@feedback_data["comment"])
      @feedback.save
    end
    @project_member = ProjectMember.find(@feedback_data["member_id"])
    @project_member.status=true
    @project_member.save
    redirect_to project_path(@project_member.project)
  end

  def create
    @feedback_data = feedback_params
    @recipient = Account.find(@feedback_data["to"])
    @created = Account.find(@feedback_data["from"])
    @feedback = Feedback.new(comment: @feedback_data["comment"], rating:@feedback_data["rating"],created:@created,recipient:@recipient)
    if @feedback.save
      @project_member = ProjectMember.find(@feedback_data["member_id"])
      @project_member.status=true
      @project_member.save
      redirect_to project_path(@project_member.project)

    else
      render :new ,status: :unprocessable_entity
    end
  end

  private
  def feedback_params
    params.require(:feedback).permit(:comment,:rating,:to,:from,:member_id)
  end
end
