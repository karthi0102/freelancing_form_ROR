class Api::ProjectStatusController < Api::ApiController
  def show
    project = Project.find_by(id: params[:id])
    if project
      if project.project_status
        render json:project.project_status,status: :ok
      else
        render json:{message:"No project status"},status: :ok
      end
    else
      render json:{message:"Project Not found"},status: :ok
    end
  end

end
