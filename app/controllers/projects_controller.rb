class ProjectsController < ApplicationController
  def index
    @projects = Project.all
  end

  def show
    @project = Project.find(params[:id])
    @freelancer = Freelancer.first
  end

  def new
    @project = Project.new
  end

  def create
    @client = Client.first
    @project_details = project_params
    @project = @client.projects.create(@project_details)
    if @client.save and @project.save
      redirect_to @project
    else
      render :new ,status: :unprocessable_entity
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

  def add_freelancer_applicant
      @project = Project.find(params[:id])
      if @project
        @freelancer = Freelancer.first
        @applicant =  @freelancer.applicants.create(status:"applied")
        @project.applicants<<@applicant
        @applicant.save
        @project.save
        @freelancer.save
        redirect_to project_path(@project)
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
      applicant_id=params[:applicable_id]
      @applicant = Applicant.find(params[:applicant_id])
      applicant_type = @applicant.applicable_type

      @project = @applicant.project
      @applicant.status="accepted"

      unless @project.project_status
        @project_status = ProjectStatus.new(start_date:DateTime.now,project: @project,status: "on-process")
        @project_status.save
      end

      if applicant_type=="Freelancer"
        @freelancer = Freelancer.find(@applicant.applicable_id)
        @project_member =@freelancer.project_members.create();
        @project.project_members<<@project_member
        @project_member.save

        @freelancer.save
        @project.save

      elsif applicant_type=="Team"
        @team = Team.find(@applicant.applicable_id)
        @project_member =@team.project_members.create();
        @project.project_members<<@project_member
        @project_member.save
        @team.save
        @project.save
      end

      @applicant.save
      @project.save

      redirect_to project_path(@project)
  end



  def reject
    @applicant = Applicant.find(params[:applicant_id])
    @project = @applicant.project
    @applicant.status="rejected"
    @applicant.save
    redirect_to profile_path(@applicant.project)
  end


  def completed
    @project = Project.find(params[:id])
    if @project
      project_status = @project.project_status
      project_status.status="completed"
      project_status.end_date=DateTime.now
      project_status.save
      @payment = Payment.new(amount:@project.amount,status:"pending")
      @payment.project_status=project_status
      @payment.save
      redirect_to new_feedback_path(to:@project.client.id,to_type:"Client",from:Freelancer.first.id,from_type:"Creelancer")
    end
  end


  private

  def project_params
    params.require(:project).permit(:name, :description, :amount)
  end




end
