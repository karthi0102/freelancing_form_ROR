class ApplicationController < ActionController::Base
    before_action :authenticate_account!
    def after_sign_in_path_for(resource)
        if resource.client?
           root_path
        elsif resource.freelancer?
            projects_path
        end
    end

    
end
