class FreelancerController < ApplicationController
  before_action :authenticate_account!
  before_action :is_client
  def index
    @freelancers=Account.where(accountable_type:"Freelancer")
    p params
    if params[:name].length!=0
      @freelancers = Account.where(accountable_type:"Freelancer").where("name LIKE?","%#{params[:name]}%")
    end
    if params[:location].length!=0
      @freelancers = Account.where(accountable_type:"Freelancer").where("location LIKE ?","%#{params[:location]}%")
    end
    if params[:skill].length!=0
      freelancer_ids_with_skill = Freelancer.joins(:skills).where("skills.name LIKE ?", "%#{params[:skill]}%").pluck(:id)
      @freelancers = Account.where(accountable_type:"Freelancer" ,accountable_id:freelancer_ids_with_skill)
    end

    if params[:rating].length!=0
      @freelancers = Account.where(accountable_type:"Freelancer").select{|account| account.ratings >= params[:rating].to_f}
    end


  end
  private
  def is_client
    unless  current_account.client?
      flash[:error] = "Unauthorized action"
      redirect_to projects_path
    end
  end
end
