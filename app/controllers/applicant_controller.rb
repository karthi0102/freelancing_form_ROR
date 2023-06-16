class ApplicantController < ApplicationController
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

end
