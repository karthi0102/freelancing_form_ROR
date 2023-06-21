class Api::ProjectsController < Api::ApiController
  before_action :is_client, only: [:new,:create,:update,:destroy,:set_available,:client]
  before_action :is_freelancer ,only: [:index]
  before_action :is_project_client,only: [:edit,:update,:destroy,:set_available]

  def index

    projects = Project.all
    if projects.empty?
      render json: {message: "No Projects"},status: :ok
    else
      render json: projects, status: :ok
    end
  end

  def show

    project = Project.find_by(id:params[:id].to_i)
    if project
      render json: project ,status: :ok
    else
      render json: {message: "No project found with this is id"},status: :ok
    end
  end




  def create
    # @client = current_account.accountable if current_account.client?
    client = Client.last
    project_data=project_params
    image=project_data["image"]
    project_data.delete("image")
    project = client.projects.create(project_data)
    project.image.attach(image)
    if client.save and project.save
      render json: {message:"Project Created",project:project},status: :ok
    else
      render json: {message: project.errors}, status: :ok
    end

  end



  def update

    project = Project.find_by(id: params[:id])
    if project.update(project_params)
      render json: {message:"Updated",project:project}, status: :ok
    else
      render json: {message:project.error},status: :ok
    end

  end

  def destroy
    project = Project.find(params[:id])
    if project.destroy
      render json: {message:"Project destroyed"},status: :ok
    else
      render json: {message:"Cannot Delete"},status: :ok
    end

  end

  def available_projects
    projects = Project.where(available:true)
    if projects.empty?
      render json: {message:"No projects found"},status: :ok
    else
      render json: projects ,status: :ok
    end
  end





  def set_available
    project = Project.find(params[:id])
    if project
      project.available=!project.available
      project.save
      render json: {message:"project status changed to #{project.available}"} ,status: :ok
    else
      render json: {message:"Cannot find a project"},status: :ok
    end

  end


  private

  def project_params
    params.require(:project).permit(:name, :description, :amount ,:image)
  end

  def is_client
    unless  current_account.client?
      render json:{message:"Unauthorized action"},status: :forbidden
    end
  end

  def is_freelancer
    unless  current_account.freelancer?
      render json:{message:"Unauthorized action"},status: :forbidden
    end
  end


  def is_project_client

    project_id=params[:id]
    project = Project.find_by(id:project_id)
    if current_account.accountable.id !=project.client.id
      render json:{message:"You are not authorized to do this acction"},status: :forbidden
    end
  end

end
