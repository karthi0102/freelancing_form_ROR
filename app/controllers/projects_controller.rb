class ProjectsController < ApplicationController
  before_action :authenticate_account!
  before_action :is_client, only: [:new,:create,:edit,:update,:destroy,:set_available,:client]
  before_action :is_freelancer ,only: [:index]
  before_action :is_project_client,only: [:edit,:update,:destroy,:set_available]


  def index
    @projects = Project.available_project
  end

  def show
    if @project = Project.find_by(id:params[:id])
       @project
       @freelancer = current_account.accountable if current_account.freelancer?
    else
      redirect_to root_path
    end

  end

  def new
      @project = Project.new
  end

  def create
    @client = current_account.accountable if current_account.client?
    project_data=project_params
    image=project_data["image"]
    project_data.delete("image")
    @project = client.projects.create(project_data)
    @project.image.attach(image)
    if @client.save and @project.save
      redirect_to @project ,notice: "Created New Project"
    else
      render :new ,status: :unprocessable_entity
    end

  end



  def edit
    if @project = Project.find(params[:id])
      @project
    else
      redirect_to  root_path
    end
  end

  def update

    project = Project.find(params[:id])

    if project.update(project_params)
      redirect_to project
    else
      render :edit, status: :unprocessable_entity
    end
  end


  def destroy
    project = Project.find_by(id: params[:id])
    if project and project.destroy
      redirect_to my_projects_path, status: :see_other
    else
      redirect_to root_path ,error:"Error while deleting"
    end

  end


  def client
    @client = current_account.accountable
  end





  def set_available
    project = Project.find_by(id: params[:id])
    if project and project.update(available:!project.available)
      redirect_to project_path(project)
    else
      redirect_to root_path
    end

  end


  private

  def project_params
    params.require(:project).permit(:name, :description, :amount ,:image)
  end

  def is_client

    unless current_account.client?
      flash[:error] = "Unauthorized action"
      redirect_to projects_path
    end
  end

  def is_freelancer
    unless  current_account.freelancer?

      flash[:error] = "Unauthorized action"
      redirect_to root_path

    end
  end


  def is_project_client

    project_id=params[:id]
    project = Project.find_by(id:project_id)
    if project
      if current_account.accountable.id !=project.client.id
        redirect_to root_path ,error: "Unauthorised Action"
      end
    else
      redirect_to root_path,error:"Not found"
    end
  end

end
