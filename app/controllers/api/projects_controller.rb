class Api::ProjectsController < Api::ApiController
  # before_action :is_client, only: [:new,:create,:edit,:update,:destroy,:set_available,:client]
  # before_action :is_freelancer ,only: [:index]
  # before_action :is_project_client,only: [:edit,:update,:destroy,:set_available]
  # before_action :authenticate_account!


  def index
    projects = Project.all
    if projects.empty?
      render json: {message: "No Projects"},status: :OK
    else
      render json: projects, status: :ok
    end
  end

  def show
    project = Project.find_by(id:params[:id])
    if project
      render json: project ,status: :ok
    else
      render json: {message: "No project found with this is"},status: :OK
    end
  end

  def new
      @project = Project.new
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


  def edit
    project = Project.find_by(id: params[:id])
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

  def client
    @client = current_account.accountable
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

    unless account_signed_in? and current_account.client?
      puts "flash"
      flash[:error] = "Unauthorized action"
      p flash[:error]
      if account_signed_in?
        redirect_to projects_path
      else
        redirect_to new_account_session_path
      end
    end
  end

  def is_freelancer
    unless account_signed_in? and current_account.freelancer?

      flash[:error] = "Unauthorized action"
      if account_signed_in?
        redirect_to root_path
      else
        flash[:error] = "Unauthorized action"
        redirect_to new_account_session_path
      end
    end
  end


  def is_project_client

    project_id=params[:id]
    project = Project.find_by(id:project_id)
    if current_account.accountable.id !=project.client.id
      redirect_to root_path ,error: "Unauthorised Action"
    end
  end

end
