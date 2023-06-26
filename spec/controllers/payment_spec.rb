require 'rails_helper'

RSpec.describe PaymentController, type: :controller do
  let(:client) {create(:client)}
  let(:client_account) {create(:account,:for_client,accountable:client)}

  let(:freelancer) {create(:freelancer)}
  let(:freelancer_account) {create(:account,:for_freelancer,accountable:freelancer)}

  let!(:project) {create(:project,client:client)}
  let!(:payment) {create(:payment)}
  let!(:project_status) {create(:project_status,project:project,payment:payment)}


  let(:project_member) {create(:project_member,project:project,memberable:freelancer)}



  describe "get /payment#new " do
    context "when user is not signed in" do
      before do
        get:new,params:{project_id:project,member_id:project_member}
      end
      it "should redirect to signin page" do
        expect(response).to redirect_to(new_account_session_path)
      end
    end

    context "when user is freelancer" do
      before do
        sign_in freelancer_account
        get:new,params:{project_id:project,member_id:project_member}
      end
      it "should redirect to projects page" do
        expect(response).to redirect_to(projects_path)
      end
    end

    context "when user is client" do
      before do
        sign_in client_account
        get:new,params:{project_id:project,member_id:project_member}

      end
      it "should redirect to projects page" do
        expect(response).to render_template(:new)
      end
    end
  end

  describe "post #payment#create" do
    context "when user is not signed in" do
      before do
        post:create,params:{project_id:project,member_id:project_member,card_number:"1234567890",card_cvv:"124",amount:3000}
      end
      it "should redirect to signin page" do
        expect(response).to redirect_to(new_account_session_path)
      end
    end
    context "when user is freelancer" do
      before do
        sign_in freelancer_account
        post:create,params:{project_id:project,member_id:project_member,card_number:"1234567890",card_cvv:"124",amount:3000}
      end
      it "should redirect to signin page" do
        expect(response).to redirect_to(projects_path)
      end
    end
    context "when user is client" do
      before do
        hash={id:project_member.id,status:"pending",paid_date:nil,amount:nil}
        payment.account_details.values.push(hash)
        payment.save
        sign_in client_account
        post:create,params:{project_id:project,member_id:project_member,card_number:"1234567890",card_cvv:"124",amount:3000}
      end
      it "should redirect to signin page" do
        expect(response).to redirect_to(my_projects_path)
      end
    end
  end
end
