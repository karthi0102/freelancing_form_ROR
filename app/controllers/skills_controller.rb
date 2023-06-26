class SkillsController < ApplicationController
  before_action :authenticate_account!
  before_action :is_freelancer

    def create
      freelancer = current_account.accountable if current_account.freelancer?
      if freelancer
        skill = freelancer.skills.create(skill_params)
        if skill.save and  freelancer.save
          redirect_to freelancer_profile_path(freelancer)
        else
          redirect_to root_path ,status: :expectation_failed
        end
      end
    end

    def destroy
      freelancer = current_account.accountable if current_account.freelancer?
      if freelancer
        skill = freelancer.skills.find_by(id: params[:id])
        if skill and skill.destroy
          redirect_to freelancer_profile_path(freelancer) ,notice:"Deleted Skill"
        else
          redirect_to freelancer_profile_path(freeelancer),error:"Skill not found"
        end
      else
        redirect_to root_path ,error:"Unauthorized action"
      end
    end

    private
    def skill_params
      params.require(:skill).permit(:name,:level)
    end

    def is_freelancer
      unless  current_account.freelancer?
        flash[:error] = "Unauthorized action"
        redirect_to root_path
      end
    end
end
