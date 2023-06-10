class FreelancerRegistrationController < ApplicationController
  def new
    @account = Account.new
    @gender = ['male','female','transgender','other']
  end
  def create
    @user_datas = freelancer_detail_params
    @user_datas["account_type"]="freelancer"
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
  def freelancer_detail_params
    params.require(:account).permit(:name, :email, :phone, :image, :password, :linkedin, :gender, :github)
  end
end

