class FreelancerRegistrationController < ApplicationController
  def new
    @account = Account.new
    @gender = ['male','female','transgender','other']
  end
  def create
    @user_datas = freelancer_detail_params
    image = @user_datas["image"]
    @user_datas.delete("image")
    experience = @user_datas["experience"]
    @user_datas.delete("experience")
    github = @user_datas["github"]
    @user_datas.delete("github")
    @freelancer = Freelancer.new(experience: experience, github: github)
    @account = Account.new(@user_datas)
    @account.image.attach(image)
    @freelancer.account=@account
    if @account.save and @freelancer.save
      redirect_to  root_path
    else
      render :new ,status: :unprocessable_entity
    end

  end
  private
  def freelancer_detail_params
    params.require(:account).permit(:name, :email, :phone, :image, :password, :linkedin, :gender, :github ,:description, :experience)
  end
end

