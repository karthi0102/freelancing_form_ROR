class ApplicantController < ApplicationController
  before_action :is_freelancer , except: [:reject]
  before_action :is_client ,only: [:reject]
  before_action :authenticate_account!



  def add_freelancer_applicant
    project = Project.find(params[:id])
    if project
      freelancer = current_account.accountable if current_account.freelancer?
      applicant =  freelancer.applicants.create(status:"applied")
      project.applicants<<applicant
      if applicant.save and project.save and freelancer.save
        redirect_to project_path(project) ,notice:"Applied Successfully"
      else
        redirect_to project_path(project) ,error:"Applied Error"
      end
    else
      redirect_to project_path(project) ,error:"Unkown Actio "
    end
end

def add_team_applicant
  project = Project.find(params[:project_id]);
  if project
    team = Team.find(params[:team_id])
    applicant=team.applicants.create(status:"applied")
    project.applicants<<applicant
    if applicant.save and project.save and team.save
      redirect_to project_path(project) ,notice:"Applied Successfully"
    else
      redirect_to project_path(project) ,error:"Applied Error"
    end

  else
    redirect_to project_path(project) ,error:"Unkown Action"
  end

end


def reject
  applicant = Applicant.find(params[:applicant_id])
  if applicant
    project = applicant.project
    applicant.status="rejected"
    if applicant.save
      redirect_to project_path(project) ,notice:"Rejected"
    else
      redirect_to project_path(project) ,notice:"Error while Rejecting"
    end
  else
    redirect_to root_path ,error:"unkown action"
  end
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

end
