class Api::ProjectMemberController < Api::ApiController
  before_action :is_client ,only: [:show,:accept]
  before_action :is_project_client ,only: [:show,:accept]
  before_action :is_freelancer ,only: [:completed]
  before_action :is_project_member, only: [:completed]
  def show
    project = Project.find_by(id: params[:id])
    if project
      if project.project_members.empty?
        render json:{message:"No Project Members"},status: :ok
      else
        render json:{project:project,project_members:project.project_members},status: :ok
      end
    else
      render json:{message:"Project not found"},status: :ok
    end
  end

  def accept
    project = Project.find_by(id:params[:project_id])
    if project
        applicant = project.applicants.find_by(id:params[:applicant_id])
        if applicant
          applicant_type = applicant.applicable_type
          applicant.status="accepted"

          if project.project_status==nil
            payment = Payment.new(amount:project.amount)
            payment.save
            project_status = ProjectStatus.new(start_date:DateTime.now,payment:payment,project:project)
            project_status.save
            payment.save
            project.save

          end

          if applicant_type=="Freelancer"
            freelancer = Freelancer.find(applicant.applicable_id)
            project_member =freelancer.project_members.create();

            project.project_members<<project_member
            project_member.save
            freelancer.save
            project.save

          elsif applicant_type=="Team"
            team = Team.find(applicant.applicable_id)
            project_member =team.project_members.create();
            project.project_members<<project_member

            project_member.save
            team.save
            project.save
          end

          applicant.save
          project.save
          render json:{message:"Accepted",project_member:project_member,project:project}
        else
          render json:{message: "Applicant not found"},status: :ok
        end
      else
        render json:{message:"Project not found"},status: :ok
      end
  end

  def completed
    project = Project.find_by(id: params[:id])
    if project
      project_member = project.project_members.find_by(id: params[:member_id])
      if project_member
        if project_member.update(status:"completed")
          render json: {message:"Status changed to completed",member:project_member},status: :ok
        else
          render json:{message:"Try after some time"},status: :ok
        end
      else
        render json:{message:"Unkown Action"},status: :ok
      end
    else
      render json:{message:"Unkown Action"},status: :ok
    end
  end







private



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
    project_id=params[:id] || params[:project_id]
    project = Project.find_by(id:project_id)
    if current_account.accountable.id !=project.client.id
      render json:{message:"You are not authorized to do this acction"},status: :forbidden
    end
  end

  def is_project_member
    project = Project.find_by(id: params[:id])
    if project.project_members.where(id :current_account.accountable).length==0
      render json:{message:"Unauthorised action"}
    end

  end


end
