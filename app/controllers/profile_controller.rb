class ProfileController < ApplicationController
  before_action :authenticate_account!
  def client
    @client = Client.find_by(id: params[:id])

  end

  def freelancer
    @freelancer = Freelancer.find_by(id: params[:id])

  end
end
