class ProjectMemberController < ApplicationController
  before_action :is_client ,only: [:accept]
  before_action :is_project_client ,only: [:accept]
  before_action :authenticate_account!
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
        else
          redirect_to project_path(project) ,error:"Applicant Not Found"
        end
      else
        redirect_to root_path ,error:"Unkown Action"
      end

    redirect_to project_path(project)
end






private

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




def is_project_client

  project_id=params[:project_id]
  project = Project.find_by(id:project_id)
  if current_account.accountable.id !=project.client.id
    redirect_to root_path ,error: "Unauthorised Action"
  end
end


end
