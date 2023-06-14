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
    @project_details["available"]=true
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

    else
      redirect_to project_path(@project)
    end
  end

  def accept
      @project = Project.find(params[:project_id])
      @applicant = @project.applicants.find(params[:applicant_id])
      applicant_type = @applicant.applicable_type
      @project= @applicant.project
      @applicant.status="accepted"

      if @project.project_status==nil
        @payment = Payment.new(amount:@project.amount,status:"pending")
        @payment.save
        @project_status = ProjectStatus.new(start_date:DateTime.now,status: "on-process",payment:@payment,project:@project)
        @payment.project_status=@project_status
        @project.project_status=@project_status
        @project_status.save
        @payment.save
        @project.save

      end

      if applicant_type=="Freelancer"
        @freelancer = Freelancer.find(@applicant.applicable_id)
        @project_member =@freelancer.project_members.create();
        @project_member.status="on-process"
        @project.project_members<<@project_member
        @project_member.save
        @freelancer.save
        @project.save

      elsif applicant_type=="Team"
        @team = Team.find(@applicant.applicable_id)
        @project_member =@team.project_members.create();
        @project.project_members<<@project_member
        @project_member.status="on-process"
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
    redirect_to project_path(@applicant.project)
  end


  def member_completed
    @project = Project.find(params[:project_id])
    if @project
      @project_member = @project.project_members.find(params[:member_id])
      if @project_member

         @project_member.save
         @project_status = @project.project_status

         @project.save
        redirect_to new_feedback_path(to:@project.client.id,to_type:"Client",from:Freelancer.first.id,from_type:"Freelancer")
      end
    end
  end

  def set_available
    @project = Project.find(params[:id])
    @project.available=!@project.available
    @project.save
    redirect_to project_path(@project)
  end

  private

  def project_params
    params.require(:project).permit(:name, :description, :amount)
  end




end
