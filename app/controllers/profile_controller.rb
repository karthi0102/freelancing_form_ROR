class ProfileController < ApplicationController
  def show
    @account = Account.find(params[:id])
    @skills=[]
    if @account.account_type=="freelancer"
      @skills=@account.skills
    end
  end
end
