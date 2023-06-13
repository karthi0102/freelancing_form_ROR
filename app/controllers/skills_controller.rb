class SkillsController < ApplicationController
    def create
      @freelancer=Freelancer.first
      if @freelancer
        @skill = @freelancer.skills.create(skill_params)
        @freelancer.save
        @skill.save
        redirect_to freelancer_profile_path(@freelancer)
      end
    end

    private
    def skill_params
      params.require(:skill).permit(:name,:level)
    end
end
