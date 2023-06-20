class Api::ApplicantController < Api::ApiController
  # before_action :is_freelancer , except: [:reject]
  # before_action :is_client ,only: [:reject]
  # before_action :authenticate_account!

  def applicants
    project = Project.find_by(id:params[:id])
    if project
      render json: {project:project,applicants:project.applicants},status: :ok
    else
      render json: {message:"project not found"},status: :ok
    end
  end


  def add_freelancer_applicant
    project = Project.find_by(id: params[:id])
    if project
      #freelancer = current_account.accountable if current_account.freelancer?
      freelancer = Freelancer.last
      applicant =  freelancer.applicants.create(status:"applied")
      project.applicants<<applicant
      if applicant.save and project.save and freelancer.save
        render json:{message: "Applicant added",applicant:applicant},status: :ok
      else
        render json:{message:"Applicant not added"},status: :ok
      end
    else
      render json:{message:"Unknown Action"},status: :ok
    end
end

def add_team_applicant
  project = Project.find_by(id: params[:project_id]);
  if project
    team = Team.find_by(id: params[:team_id])
    if team
      applicant=team.applicants.create(status:"applied")
      project.applicants<<applicant
      if applicant.save and project.save and team.save
        render json:{message:"Applied for project #{project.name}",applicant:applicant},status: :ok
      else
        render json:{message:"Errro"} ,status: :ok
      end
    else
      render json: {message:"Unknow Action"},status: :ok
    end

  else
    render json:{message:"Unknown Action"},status: :ok
  end

end


def reject
  applicant = Applicant.find_by(id: params[:applicant_id])
  if applicant
    project = applicant.project
    applicant.status="rejected"
    if applicant.save
      render json:{message:"Rejected",applicant:applicant},status: :ok
    else
      render json:{message:"Error while process"},status: :ok
    end
  else
    render json:{message:"Unkown Action"},status: :ok
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
