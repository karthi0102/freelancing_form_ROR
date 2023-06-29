module ClientAction
  extend ActiveSupport::Concern

  def is_client
    unless current_account.client?
      flash[:error] = "Unauthorized action"
      redirect_to projects_path
    end
  end
  def is_project_client
   
    if current_account.accountable != @project.client
      redirect_to root_path ,error: "Unauthorised Action"
    end

  end
  def find_project
    puts "hii 1"
    id = params[:id] or params[:project_id]
    if Project.exists? :id => id
      @project = Project.find_by(id: id)
    else
      flash[:error]="Project not found"
      redirect_to root_path
    end
  end
end
