module FreelancerAction
  extend ActiveSupport::Concern


  def is_freelancer
    unless  current_account.freelancer?
      flash[:error] = "Unauthorized action"
      redirect_to root_path
    end
  end


end
