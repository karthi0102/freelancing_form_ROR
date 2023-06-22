class Api::ProjectStatusController < Api::ApiController
  before_action :is_client
  before_action :is_project_client
  def show
    project = Project.find_by(id: params[:id])
    if project
      if project.project_status
        render json:project.project_status,status: :ok
      else
        render json:{message:"No project status"},status: :no_content
      end
    else
      render json:{message:"Project Not found"},status: :not_found
    end
  end

  private
  def is_client
    unless current_account and  current_account.client?
      render json:{message:"Unauthorized action"},status: :unauthorized
    end
  end

  

  def is_project_client

    project_id=params[:id]
    project = Project.find_by(id:project_id)
    if current_account.accountable.id !=project.client.id
      render json:{message:"You are not authorized to do this acction"},status: :unauthorized
    end
  end
end
