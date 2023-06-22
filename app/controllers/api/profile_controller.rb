class Api::ProfileController < Api::ApiController
  def freelancer
    freelancer = Freelancer.find_by(id: params[:id])
    if freelancer
      render json:{freelancer:freelancer,account:freelancer.account,feedback:freelancer.account.recipient_feedbacks,skills:freelancer.skills,rating:freelancer.account.ratings,teams:freelancer.teams}
    else
      render json:{message:"Profile not found"},status: :not_found
    end
  end

  def client
    client = Client.find_by(id:params[:id])
    if client
      render json:{client:client,account:client.account,project:client.projects,feedbacks:client.account.recipient_feedbacks,rating:client.account.ratings}
    else
      render json:{message:"Profile not found"},status: :not_found
    end
  end


end
