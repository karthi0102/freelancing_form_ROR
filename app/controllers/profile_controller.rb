class ProfileController < ApplicationController
  def show
    @account = Account.find(params[:id])
    @skills=[]
    if @account.account_type=="freelancer"
      @skills=@account.skills
    end
  end


  def client
    @client = Client.find(params[:id])

  end
  def freelancer
    @freelancer = Freelancer.find(params[:id])
  end
end
