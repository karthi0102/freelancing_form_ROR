class ApplicationController < ActionController::Base
    before_action :authenticate_account!
    def after_sign_in_path_for(resource)
        if resource.client?
            my_projects_path
        elsif resource.freelancer?
            projects_path
        end
    end
end
