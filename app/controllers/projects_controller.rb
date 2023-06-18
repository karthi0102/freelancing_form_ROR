class ProjectsController < ApplicationController
  before_action :is_client, only: [:new,:create,:edit,:update,:destroy,:set_available]
  before_action :is_freelancer ,only: [:index]
  before_action :is_project_client,only: [:edit,:update,:destroy,:set_available]


  def index
    @projects = Project.available_project
  end

  def show
    @project = Project.find_by(id:params[:id])
    @freelancer = current_account.accountable if current_account.freelancer?

  end

  def new
      @project = Project.new
  end

  def create
    client = current_account.accountable if current_account.client?
    project_data=project_params
    image=project_data["image"]
    project_data.delete("image")
    project = client.projects.create(project_data)
    project.image.attach(image)
    if client.save and project.save
      redirect_to project ,notice: "Created New Project"
    else
      render :new ,status: :unprocessable_entity
    end

  end



  def edit
    @project = Project.find(params[:id])
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
    project = Project.find(params[:id])
    project.destroy

    redirect_to projects_path, status: :see_other
  end


  def client
    @client = current_account.accountable
  end





  def set_available
    @project = Project.find(params[:id])
    @project.available=!@project.available
    @project.save
    redirect_to project_path(@project)
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
