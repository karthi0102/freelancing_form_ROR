class Api::BankAccountDetailsController < Api::ApiController
  before_action :is_freelancer ,only: [:new,:create]
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
        new_hash = {id:project_member.id ,amount:nil,paid_date:nil,account_number:params["account_number"],ifsc_code:params["ifsc_code"],status:"pending"}
        if project.project_members.length == project.project_members.where(status:"completed").length
          project_status.update(status:"completed")
        end
        payment=project.payment
        payment.account_details["values"]<<new_hash
        if payment.save and project.save
          render json:{message:"Account Details added",payment:payment},status: :created
        else
          render json:{message:"Error",error:payment.errors},status: :unprocessable_entity
        end
      else
        render json:{message:"Project not found"},status: :not_found
      end
    else
     render json:{message:"wrong data"},status: :unprocessable_entity
    end
  end


  private
  def bank_account_details_params
      params.permit(:project_id, :member_id, :account_number,:ifsc_code)
  end

 

  def is_freelancer
    unless current_account and  current_account.freelancer?
      render json:{message:"Unauthorized action"},status: :unauthorized
    end
  end


end
