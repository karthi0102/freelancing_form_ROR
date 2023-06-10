class ProjectsController < ApplicationController
  def index
    @projects = Project.all
  end
  def show
    @project = Project.find(params[:id])
    @applicants=[]
    @project.applicants.each do |applicant|
      accnt = Account.find(applicant.account_id);
      @applicants<<accnt
    end
  end
  def new
    @project = Project.new
  end

  def create
    @account = Account.first
    if @account.account_type=="client"
      @project_details = project_params
      @project_details["status"]="created"
      @project = @account.projects.create(@project_details)
      if @account.save and @project.save
        redirect_to @project
      else
        render :new ,status: :unprocessable_entity
      end
  end
  end

  def edit
    @project = Project.find(params[:id])
  end

  def update
    @project = Project.find(params[:id])

    if @project.update(project_params)
      redirect_to @project
    else
      render :edit, status: :unprocessable_entity
    end
  end
  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    redirect_to projects_path, status: :see_other
  end


  def mine
    @account = Account.find(params[:id])
  end

  def add_applicant
      @project = Project.find(params[:id])
      if @project
        @account = Account.last
        @applicant =  Applicant.new({"status":"applied"})
        @project.applicants<<@applicant
        @account.applicants<<@applicant
        @applicant.save
        @project.save
        @account.save
        redirect_to profile_path(@account)
      else
        redirect_to project_path(@project)
      end
  end

  def accept
    @project =
  end

  private

  def project_params
    params.require(:project).permit(:name, :description, :amount)
  end




end
