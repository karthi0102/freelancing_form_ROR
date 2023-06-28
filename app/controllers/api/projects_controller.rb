class Api::ProjectsController < Api::ApiController
  before_action :is_client, only: [:new,:create,:update,:destroy,:set_available,:client]
  before_action :is_freelancer ,only: [:index,:freelancer,:available_projects]
  before_action :is_project_client,only: [:edit,:update,:destroy,:set_available]


  def index

    projects = Project.all
    if projects.empty?
      render json: {message: "No Projects"},status: :no_content
    else
      render json: projects,except: [:created_at, :updated_at], status: :ok
    end
  end

  def show

    project = Project.find_by(id:params[:id].to_i)
    if project

      render json: project,except: [:created_at, :updated_at] ,status: :ok
    else
      render json: {message: "No project found with this is id"},status: :not_found
    end
  end




  def create
    client = current_account.accountable if current_account.client?
    if client
      project_data=project_params
      image=project_data["image"]
      project_data.delete("image")
      project = client.projects.create(project_data)
      project.image.attach(image)
      if client.save and project.save
        render json: {message:"Project Created",project:project},status: :created
      else
        render json: {message: project.errors}, status: :unprocessable_entity
      end
    else
      render json:{message:"Account not found"},status: :not_found
    end

  end



  def update

    project = current_account.accountable.projects.find_by(id: params[:id])
    if project and  project.update(project_params)
      render json: {message:"Updated",project:project}, status: :ok
    else
      render json: {message:project.errors},status: :unprocessable_entity
    end

  end

  def destroy
    project = current_account.accountable.projects.find_by(id: params[:id])
    if project
      if project.destroy
        render json: {message:"Project destroyed"},status: :see_other
      else
        render json: {message:"Cannot Delete"},status: :unprocessable_entity
      end
    else
      render json:{message:"not found"},status: :not_found
    end
  end

  def available_projects
    projects = Project.where(available:true)
    if projects.empty?
      render json: {message:"No projects found"},status: :no_content
    else
      render json: projects ,status: :ok
    end
  end


  def client
    client = current_account.accountable if current_account.client?
    if client
        render json:{projects:client.projects},status: :ok
    else
      render json:{message:"Not found"},status: :not_found
    end
  end

  def freelancer
    freelancer = current_account.accountable if current_account.freelancer?
    if freelancer
        render json:{projects:freelancer.projects},status: :ok
    else
      render json:{message:"Not found"},status: :not_found
    end
  end


  def team
    team = Team.find_by(id: params[:id])
    if team
      render json:{projects:team.projects},status: :ok
    else
      render json:{message:"not found"},status: :not_found
    end
  end





  def set_available
    project = current_account.accountable.projects.find_by(id: params[:id])
    if project
      project.available=!project.available
      project.save
      render json: {message:"project status changed to #{project.available}"} ,status: :ok
    else
      render json: {message:"Cannot find a project"},status: :not_found
    end

  end


  private

  def project_params
    params.require(:project).permit(:name, :description, :amount ,:image)
  end

  def is_client
    unless current_account and  current_account.client?
      render json:{message:"Unauthorized action"},status: :unauthorized
    end
  end

  def is_freelancer
    unless current_account and  current_account.freelancer?
      render json:{message:"Unauthorized action"},status: :unauthorized
    end
  end


  def is_project_client

    project_id=params[:id]
    project = Project.find_by(id:project_id)
    if project and current_account.accountable.id !=project.client.id
      render json:{message:"You are not authorized to do this acction"},status: :unauthorized
    end
  end

end
