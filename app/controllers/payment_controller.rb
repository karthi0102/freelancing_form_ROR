class PaymentController < ApplicationController
  before_action :authenticate_account!
  before_action :is_client
  def new
    @project = Project.find(params[:project_id].to_i)
    @member = @project.project_members.find(params[:member_id].to_i)
    @payment = @project.payment
    @account_details = @payment.account_details["values"].select {|h| h[:id]=@member.id}[0]

  end


  def create
    params= payment_params
    project = Project.find(params[:project_id])
    payment = project.payment
    project_member = project.project_members.find_by(id: params[:member_id])
    account_details= payment.account_details
    account_details["values"].each do |h|
      if h["id"] == project_member.id
        h["status"] ="completed"
        h["amount"]=params["amount"].to_f
        h["paid_date"]=DateTime.now
      end
    end
    payment.save
    len= account_details["values"].select {|h| h["status"]="completed"}.length
    if account_details["values"].length == len
      payment.status="completed"
      payment.save
    end
    redirect_to my_projects_path
  end
  private
  def payment_params
    params.permit(:project_id,:member_id,:card_number,:card_expiry,:card_cvv,:amount)
  end
  def is_client
    unless current_account.client?
      flash[:error] = "Unauthorized action"
      redirect_to projects_path
    end
  end
end
