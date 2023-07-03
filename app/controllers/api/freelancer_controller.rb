class Api::FreelancerController < Api::ApiController
  include ClientAction
  before_action :is_client
  def index
    accounts=Account.where(accountable_type:"Freelancer")
    freelancers = Array.new
    accounts.each do |account|
      freelancers.push(account)
    end

    if  params[:skill] and params[:skill].length!=0
      freelancer_ids_with_skill = Freelancer.joins(:skills).where("skills.name LIKE ?", "%#{params[:skill]}%").pluck(:id)
      freelancers = Account.where(accountable_type:"Freelancer" ,accountable_id:freelancer_ids_with_skill)
    end
    if params[:name] and params[:name].length!=0
      name_pattern = /#{params[:name].downcase}/
      freelancers = freelancers.select{|account| account.name =~ name_pattern}
    end
    if  params[:location] and params[:location].length!=0
      location_pattern = /#{params[:location].downcase}/
      freelancers = freelancers.select{|account| account.location =~ location_pattern }
    end

    if params[:rating] and params[:rating].length!=0
      freelancers = freelancers.select{|account| account.ratings >= params[:rating].to_f}
    end
    render json: freelancers ,status: :ok
  end
end

