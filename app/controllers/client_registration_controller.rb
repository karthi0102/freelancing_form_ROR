class ClientRegistrationController < ApplicationController
  def new
    @account = Account.new
    @client=Client.new
    @gender=['male','female','transgender','others']

  end
  def create
    byebug
    @client_data=client_details_params
    byebug
    company = @client_data["company"] || "l"
    company_location = @client_data["company_location"] || "l"
    image= @client_data["image"]
    @client_data.delete("company")
    @client_data.delete("company_location")
    @client_data.delete("image")
    @client = Client.new(company: company ,company_location: company_location)
    @account = Account.new(@client_data)
    @account.image.attach(image)

    @client.account=@account
    byebug
    if @client.save and @account.save
      byebug
      redirect_to root_path
    else
      render :new ,status: :unprocessable_entity
    end

  end

  private
  def client_details_params
    params.require(:account).permit(:name, :email, :phone, :image, :password, :linkedin, :gender ,:description)
  end
end
