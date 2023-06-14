class BankAccountDetailsController < ApplicationController
  def new
    @project_id = params[:project_id]
    @member_id = params[:member_id]
  end

  def create
    @params = bank_account_details_params
    @project = Project.find(@params[:project_id])
    if @project
      @project_status = @project.project_status
      @project_member = @project.project_members.find(@params[:member_id])

      if @project_member
        new_hash = {id:@project_member.id ,amount:nil,paid_date:nil,account_number:@params["account_number"],ifsc_code:@params["ifsc_code"],status:"pending"}
        @project_member.status="completed"
        @project_member.save
        if @project.project_members.length == @project.project_members.where(status:"completed").length
          @project_status.status = "completed"
          @project_status.save
        end
        @payment
        if @project.payment
          @payment = @project.payment
        else
          @payment = Payment.new(amount:@project.amount,status:"pending")
          @payment.project_status=@project_status
        end
        @payment.account_details["values"]<<new_hash
        @payment.save
        @project.save
        if @project_member.memberable_type=="Freelancer"
          redirect_to new_feedback_path(to:@project.client.account,from:@project_member.memberable.account,member_id:@project_member)
        else
          redirect_to new_feedback_path(to:@project.client.account,from:@project_member.memberable.admin.account,member_id:@project_member)
        end
      end
    end
  end

  private
  def bank_account_details_params
      params.permit(:project_id, :member_id, :account_number,:ifsc_code)
  end
end
