class Api::SkillsController < Api::ApiController
  before_action :is_freelancer
    def show
      freelancer =  Freelancer.find_by(id: params[:id])
      if freelancer
        render json:{freelancer:freelancer,skills:freelancer.skills},status: :ok
      else
        render json:{message:"Account not found"},status: :not_found
      end
    end

    def create
      freelancer = current_account.accountable if current_account.freelancer?
      if freelancer
        skill = freelancer.skills.create(skill_params)
        if skill.save and freelancer.save
          render json: {message:"Skill Added to Freelacner",skill: skill},status: :created
        else
          render json: {message:"Skill not added "} ,status: :expectation_failed
        end
      else
        render json: {message:"Account not found"},status: :not_found
      end
    end

    def destroy
      freelancer = current_account.accountable if current_account.freelancer?
      if freelancer
        skill = freelancer.skills.find_by(id: params[:id])
        if skill and  skill.destroy
          render json: {message:"Skill Destroyed"},status: :ok
        else
          render json:{message:"error",error:skill.errors},status: :unprocessable_entity
        end
      else
        render json: {message:"Unauthorised action"},status: :not_found
      end
    end

    private
    def skill_params
      params.require(:skill).permit(:name,:level)
    end

    def is_freelancer
      unless current_account and  current_account.freelancer?
        render json:{message:"Unauthorized action"},status: :unauthorized
      end
    end


end
