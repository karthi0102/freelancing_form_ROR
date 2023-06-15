class PaymentController < ApplicationController
  def new
    @project = Project.find(params[:project_id].to_i)
    @member = @project.project_members.find(params[:member_id].to_i)
    @payment = @project.payment
    @account_details = @payment.account_details["values"].select {|h| h[:id]=@member.id}[0]
    @payment = @project.payment
  end


  def create
    @params= payment_params
    @project = Project.find(@params[:project_id])
    @payment = @project.payment
    @project_member = @project.project_members.find(@params[:member_id])
    @account_details= @payment.account_details
    @account_details["values"].each do |h|
      if h["id"] == @project_member.id
        h["status"] ="completed"
        h["amount"]=@params["amount"].to_f
        h["paid_date"]=DateTime.now
      end
    end
    @payment.save
    l= @account_details["values"].select {|h| h["status"]="completed"}.length
    if @account_details["values"].length == 1
      @payment.status="completed"
      @payment.save
    end
    redirect_to root_path
  end
  private
  def payment_params
    params.permit(:project_id,:member_id,:card_number,:card_expiry,:card_cvv,:amount)
  end
end
