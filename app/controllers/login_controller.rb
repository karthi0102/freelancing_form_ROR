class LoginController < ApplicationController
  def new
  end

  def create
    @account = Account.find_by(email: params[:email])

    if @account and @account.authenticate(params[:password])
      redirect_to root_path
    else
      render :login ,status: :unprocessable_entity
    end
  end

end

