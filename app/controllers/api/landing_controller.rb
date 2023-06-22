class Api::LandingController < Api::ApiController
  def index
    render json:{message:"Welcome to freelancing forum"},status: :ok
  end
end
