class BankAccountDetailsController < ApplicationController
  before_action :authenticate_account!
  include FreelancerAction
  before_action :is_freelancer ,only: [:new,:create]
  def new
    @project_id = params[:project_id].to_i
    @member_id = params[:member_id].to_i
  end

  def create
    b1 = if(params["account_number"].length < 8 or params["account_number"].length >12)
          true
          else
            false
          end
    b2 = if (params["ifsc_code"].length!=11)
      true
    else
      false
    end

    if !b1 and !b2
      params = bank_account_details_params
      project = Project.find_by(id: params[:project_id])
      if project
        project_status = project.project_status
        project_member = project.project_members.find_by(id: params[:member_id])

          if project_member
            new_hash = {id:project_member.id ,amount:nil,paid_date:nil,account_number:params["account_number"],ifsc_code:params["ifsc_code"],status:"pending"}
            project_member.status="completed"
            project_member.save
            if project.project_members.length == project.project_members.where(status:"completed").length
              project_status.status = "completed"
              project_status.save
            end
            payment=project.payment
            payment.account_details["values"]<<new_hash
            if payment.save and project.save
              if project_member.memberable_type=="Freelancer"
                redirect_to new_feedback_path(to:project.client.account,from:project_member.memberable.account,member_id:project_member)
              else
                redirect_to new_feedback_path(to:project.client.account,from:project_member.memberable.admin.account,member_id:project_member)
              end
          end
        end
      end
    else
      flash[:error]="Incorrent Datas"
      render :new ,status: :unprocessable_entity
    end

  end

  private
  def bank_account_details_params
      params.permit(:project_id, :member_id, :account_number,:ifsc_code)
  end


end
