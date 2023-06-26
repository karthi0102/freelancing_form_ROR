class FeedbackController < ApplicationController

  before_action :authenticate_account!

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
    @member_id=params[:member_id].to_i
  end

  def team_create

    feedback_data = feedback_params
    team = Team.find_by(id:feedback_data["to"])
    project_member = ProjectMember.find_by(id: feedback_data["member_id"])
    account = Account.find_by(id: feedback_data["from"])

    team.freelancers.each do |member|
      feedback = Feedback.new(created:account,recipient:member.account,rating:feedback_data["rating"],comment:feedback_data["comment"])
      feedback.save
    end
    project_member.feedback = true
    project_member.save

    redirect_to client_profile_path(account.accountable)
  end

  def create
    feedback_data = feedback_params
    recipient = Account.find_by(id: feedback_data["to"])
    created = Account.find_by(id: feedback_data["from"])
    project_member = ProjectMember.find_by(id: feedback_data["member_id"])
    @feedback = Feedback.new(comment: feedback_data["comment"], rating:feedback_data["rating"],created:created,recipient:recipient)
    if @feedback.save
      if created.freelancer?
        redirect_to freelancer_profile_path(created.accountable)
      else
        project_member.feedback=true
        project_member.save
        redirect_to client_profile_path(created.accountable)
      end
    else
      render :new ,status: :unprocessable_entity
    end
  end

  private
  def feedback_params
    params.require(:feedback).permit(:comment,:rating,:to,:from,:member_id)
  end
end
