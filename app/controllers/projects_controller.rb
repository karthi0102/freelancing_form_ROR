class ProjectsController < ApplicationController
  include ClientAction
  include FreelancerAction
  before_action :authenticate_account!
  before_action :find_project, only: [:show,:edit,:update,:destroy,:set_available]
  before_action :is_client, only: [:new,:create,:edit,:update,:destroy,:set_available,:client]
  before_action :is_freelancer ,only: [:index]
  before_action :is_project_client,only: [:edit,:update,:destroy,:set_available]


  def index
    @projects = Project.available_project
  end

  def show
       @project
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
    @project = client.projects.create(project_data)
    @project.image.attach(image)
    if @project.save and  client.save
      redirect_to @project ,notice: "Created New Project"
    else
      render :new ,status: :unprocessable_entity
    end

  end



  def edit
    @project
  end

  def update
      if @project.update(project_params)
        redirect_to @project
      else
        render :edit, status: :unprocessable_entity
      end
  end


  def destroy
      if @project.destroy
        redirect_to my_projects_path, status: :see_other
      else
        redirect_to root_path ,error:"Error while deleting"
      end
  end


  def client

    @client = current_account.accountable
    @projects =@client.projects.page(params[:page])

  end


  def set_available
      if @project.update(available:!@project.available)
        redirect_to project_path(@project),notice:"Changed availability"
      else
        flash[:error]="Error while updating"
        redirect_to root_path
      end
  end

  private

  def project_params
    params.require(:project).permit(:name, :description, :amount ,:image)
  end

end
