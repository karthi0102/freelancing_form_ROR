class Api::PaymentController < Api::ApiController
  before_action :is_client

  def show
    project = Project.find_by(id:params[:id])
    if project
        render json:{project:project,payment:project.payment},status: :ok
    else
      render json:{message:"Project not found"},status: :ok
    end
  end

  def create
    params= payment_params
    project = Project.find_by(id: params[:project_id])

    if project
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

      len= account_details["values"].select {|h| h["status"]="completed"}.length

      if account_details["values"].length == len
        payment.status="completed"
      end

      if payment.save
        render json:payment ,status: :ok
      else
        render json:{message:"Error",error:payment.errors},status: :ok
      end

    else
      render json:{message:"Project not found"},status: :ok
    end

  end


  private
  def payment_params
    params.permit(:project_id,:member_id,:card_number,:card_expiry,:card_cvv,:amount)
  end
  def is_client
    unless  current_account.client?
      render json:{message:"Unauthorized action"},status: :forbidden
    end
  end
end
