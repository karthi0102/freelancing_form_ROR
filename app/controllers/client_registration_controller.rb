class ClientRegistrationController < ApplicationController
  def new
    @account = Account.new
    @client=Client.new
  end

  def create

    @client_data=client_params
    @account_data=account_params

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

    if @client.save and @account.save

      redirect_to root_path
    else
      render :new ,status: :unprocessable_entity
    end
  end

  private
  
  def client_params
    params.require(:client).permit(:company, :company_location)
  end
  def account_params

    params.require(:account_attributes).permit(:name, :email, :phone, :image, :password, :linkedin, :gender ,:description)
  end
end
