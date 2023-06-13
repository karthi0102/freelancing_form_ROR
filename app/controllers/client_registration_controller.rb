class ClientRegistrationController < ApplicationController
  def new
    @account = Account.new
    @gender=['male','female','transgender','others']

  end
  def create
    @client_data=client_details_params
    company = @client_data["company"]
    company_location = @client_data["company_location"]
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
  def client_details_params
    params.require(:account).permit( :name, :email, :phone, :image, :password, :linkedin, :gender ,:description , :company , :company_location  )
  end
end
