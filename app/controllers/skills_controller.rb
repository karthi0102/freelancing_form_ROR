class SkillsController < ApplicationController
    def create
      @account=Account.last
      if @account and @account.account_type=="freelancer"
        @skill = @account.skills.create(skill_params)
        @account.save
        @skill.save
        redirect_to profile_path(@account)
      end
    end

    private
    def skill_params
      params.require(:skill).permit(:name,:level)
    end
end
