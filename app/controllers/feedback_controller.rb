class FeedbackController < ApplicationController
  def new
    @feedback=Feedback.new
    @to=params[:to].to_i
    @from=params[:from].to_i
    @to_type=params[:to_type]
    @from_type=params[:from_type]
  end

  def team
    @feedback=Feedback.new
    @to=params[:to].to_i
    @from=params[:from].to_i
  end
  def team_create
    @feedback_data = feedback_params
    @team = Team.find(@feedback_data["to"])
    @client = Client.find(@feedback_data["from"])
    @team.freelancers.each do |member|
      @feedback = Feedback.new(to:member.id,to_type:"Freelancer",from:@client.id,from_type:"Client",rating:@feedback_data["rating"],comment:@feedback_data["comment"])
      @feedback.save
    end
    redirect_to root_path
  end

  def create
    @feedback_data = feedback_params
    @feedback = Feedback.new(feedback_params)
    if @feedback.save
      redirect_to root_path
    else
      render :new ,status: :unprocessable_entity
    end
  end
  
  private
  def feedback_params
    params.require(:feedback).permit(:comment,:rating,:to,:from,:to_type,:from_type)
  end
end
