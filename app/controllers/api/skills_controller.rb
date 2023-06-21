class Api::SkillsController < Api::ApiController
  before_action :is_freelancer
    def show
      freelancer =  Freelancer.find_by(id: params[:id])
      if freelancer
        render json:{freelancer:freelancer,skills:freelancer.skills},status: :ok
      else
        render json:{message:"Account not found"},status: :unprocessable_entity
      end
    end
    def create
      freelancer = current_account.accountable if current_account.freelancer?
      if freelancer
        skill = freelancer.skills.create(skill_params)
        if skill.save and freelancer.save
          render json: {message:"Skill Added to Freelacner",skill: skill},status: :ok
        else
          render json: {message:"Skill not added "} ,status: :ok
        end
      else
        render json: {message:"Unkown Action"},status: :ok
      end
    end


    def destroy
      freelancer = current_account.accountable if current_account.freelancer?
      if freelancer
        skill = freelancer.skills.find_by(id: params[:id])
        skill.destroy
        render json: {message:"Skill Destroyed"}
      else
        render json: {message:"Unauthorised action"}
      end
    end

    private
    def skill_params
      params.require(:skill).permit(:name,:level)
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
