class PaymentController < ApplicationController
  def new
    @project = Project.find(params[:id])
    @payment = @project.payment
  end
  def create
    @project = Project.find(params[:id])
    @payment = @project.payment
    if @project and @project.payment
      @payment.status="completed"
      @payment.paid_date=DateTime.now
      @payment.save
      @project.save
    end
    redirect_to project_path(@project)
  end

end
