class ProfileController < ApplicationController
  before_action :authenticate_account!
  def client
    if Client.exists? :id => params[:id]
       @client = Client.find_by(id: params[:id])
    else
      redirect_to  root_path ,error:"Client not found"
    end

  end

  def freelancer
    if Freelancer.exists? :id => params[:id]
      @freelancer = Freelancer.find_by(id: params[:id])
    else
      redirect_to  root_path ,error:"Client not found"
    end
  end
end
