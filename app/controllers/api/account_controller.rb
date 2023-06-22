class Api::AccountController < Api::ApiController
  def freelancers
    freelancers = Freelancer.all
    if freelancers.empty?
      render json:{message:"No freelancer found"},status: :no_content
    else
      render json:{freelancers:freelancers},status: :ok
    end
  end

  def clients
    clients = Client.all
    if clients.empty?
      render json:{message:"No Client found"},status: :no_content
    else
      render json:{clients:clients},status: :ok
    end
  end
end
