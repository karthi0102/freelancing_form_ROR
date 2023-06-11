class ProjectsController < ApplicationController
  def index
    @projects = Project.all
  end
  def show
    @project = Project.find(params[:id])
    @account = Account.last
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

  def add_account_applicant
      @project = Project.find(params[:id])
      if @project
        @account = Account.last
        @applicant =  @account.applicants.create(status:"applied")
        @project.applicants<<@applicant
        @applicant.save
        @project.save
        @account.save
        redirect_to profile_path(@account)
      else
        redirect_to project_path(@project)
      end
  end

  def add_team_applicant
    @project = Project.find(params[:project_id]);
    if @project
      @team = Team.find(params[:team_id])
      @applicant=@team.applicants.create(status:"applied")
      @project.applicants<<@applicant
      @applicant.save
      @project.save
      @team.save
      redirect_to team_path(@team)
    else
      redirect_to project_path(@project)
    end
  end

  def accept
      applicant_type=params[:applicant_type]
      applicant_id=params[:applicable_id]
      @applicant = Applicant.find(params[:applicant_id])
      @project = @applicant.project
      if applicable_type=="account"
        @applicant.status="accepted"
        @applicant.save
        @project_status = ProjectStatus.new({start_date:DateTime.now})
        @project.project_status=@project_status
        @project.save
        @project_status.save
      else

      end
      redirect_to profile_path(@applicant.applicable)
  end



  def reject
    @applicant = Applicant.find(params[:applicant_id])
    @project = @applicant.project
    @applicant.status="rejected"
    @applicant.save
    redirect_to profile_path(@applicant.applicable)
  end



  private

  def project_params
    params.require(:project).permit(:name, :description, :amount)
  end




end
