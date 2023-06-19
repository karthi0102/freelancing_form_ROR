class SkillsController < ApplicationController
  before_action :is_freelancer
  before_action :authenticate_account!

    def create
      freelancer = current_account.accountable if current_account.freelancer?
      if freelancer
        skill = freelancer.skills.create(skill_params)
        skill.save
        freelancer.save
        redirect_to freelancer_profile_path(freelancer)
      end
    end


    def destroy
      freelancer = current_account.accountable if current_account.freelancer?
      if freelancer
        skill = freelancer.skills.find_by(id: params[:id])
        skill.destroy
        redirect_to freelancer_profile_path(freelancer) ,notice:"Deleted Skill"
      else
        redirect_to root_path ,error:"Unauthorized action"
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
