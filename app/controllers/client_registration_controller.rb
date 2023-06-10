class ClientRegistrationController < ApplicationController
  def new
    @account = Account.new
    @gender=['male','female','transgender','others']

  end
  def create
    @user_datas = client_details_params
    @user_datas["account_type"]="client"
    @user_datas["github"]=nil
    image = @user_datas["image"]
    @user_datas.delete("image")
    @account = Account.new(@user_datas)
    if @account.save
      @account.image.attach(image)
      redirect_to profile_path(@account)
    else
      render :new ,status: :unprocessable_entity
    end
  end

  private
  def client_details_params
    params.require(:account).permit( :name, :email, :phone, :image, :password, :linkedin, :gender ,:account_type )
  end
end
