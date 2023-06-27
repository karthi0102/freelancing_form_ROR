class Api::ApplicantController < Api::ApiController
  before_action :is_freelancer , only: [:freelancer_applications,:team_applications,:add_freelancer_applicant,:add_team_applicant]
  before_action :is_project_client, only: [:applicants,:reject]
  before_action :is_client ,only: [:applicants,:reject]

  def applicants
    project = Project.find_by(id:params[:id])
    if project
      render json: {project:project,applicants:project.applicants},status: :ok
    else
      render json: {message:"project not found"},status: :not_found
    end
  end

  def freelancer_applications
    freelancer = current_account.accountable
    if freelancer
      render json:{
        applied:freelancer.applicants.where(status:"applied"),
        accepted:freelancer.applicants.where(status:"accepted"),
        rejected:freelancer.applicants.where(status:"rejected")
      },status: :ok
    else
      render json:{message:"Account Not found"},status: :not_found
    end
  end

  def team_applications
    team = Team.find_by(id: params[:id])
    if team
      render json:{
        applied:team.applicants.where(status:"applied"),
        accepted:team.applicants.where(status:"accepted"),
        rejected:team.applicants.where(status:"rejected")
      },status: :ok
    else
      render json:{message:"team Not found"},status: :not_found
    end
  end


  def add_freelancer_applicant
    project = Project.find_by(id: params[:id])
    if project
      freelancer = current_account.accountable if current_account.freelancer?
      applicant =  freelancer.applicants.create(status:"applied")
      project.applicants<<applicant
      if applicant.save and project.save and freelancer.save
        render json:{message: "Applicant added",applicant:applicant},status: :created
      else
        render json:{message:"Applicant not added"},status: :expectation_failed
      end
    else
      render json:{message:"Project not found"},status: :not_found
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
        render json:{message:"Applied for project #{project.name}",applicant:applicant},status: :created
      else
        render json:{message:"Error"} ,status: :exception_failed
      end
    else
      render json: {message:"Team not found"},status: :not_found
    end

  else
    render json:{message:"Project not found"},status: :not_found
  end

end


def reject

  project = Project.find_by(id: params[:project_id])
  if project
    applicant = project.applicants.find(params[:applicant_id])
    if applicant
      if applicant.update(status:"rejected")
        render json:{message:"Rejected",applicant:applicant},status: :ok
      else
        render json:{message:"Error while process"},status: :unprocessable_entity
      end
    else
      render json:{message:"Applicant not found"},status: :not_found
    end
  else
    render json:{message:"Project not found"},status: :not_found
  end
end

private
    def is_client

      unless current_account and  current_account.client?
        render json:{message:"Unauthorized action"},status: :unauthorized
      end
    end

    def is_freelancer
      unless current_account and  current_account.freelancer?
        render json:{message:"Unauthorized action"},status: :unauthorized
      end
    end
    def is_project_client
      project_id=params[:project_id] || params[:id]
      project = Project.find_by(id:project_id)

      if project and current_account.accountable.id != project.client.id

        render json:{message:"You are not authorized to do this action"},status: :unauthorized
      end
    end


end
