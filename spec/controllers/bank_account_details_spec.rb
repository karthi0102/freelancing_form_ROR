require 'rails_helper'

RSpec.describe BankAccountDetailsController, type: :controller do

  let!(:client) {create(:client)}
  let!(:client_account) {create(:account,:for_client,accountable:client)}


  let!(:freelancer) {create(:freelancer)}
  let!(:freelancer_account) {create(:account,:for_freelancer,accountable:freelancer)}

  let!(:project) {create(:project,client:client)}
  let!(:project_member) {create(:project_member,project:project,memberable:freelancer)}
  let!(:payment) {create(:payment)}
  let!(:project_status) {create(:project_status,project:project,payment:payment)}

  let!(:team) {create(:team,admin:freelancer)}
  let!(:project_member1) {create(:project_member,memberable:team,project:project)}

  describe "get /bankdetails:new" do
    context "when account not sigend in" do
      before do
         get :new ,params:{project_id:project,member_id:project_member}
      end
      it "should redirect sign in page" do
        expect(response).to redirect_to(new_account_session_path)
      end
    end
    context "when account  sigend in is client" do
      before do
         sign_in client_account
         get :new ,params:{project_id:project,member_id:project_member}
      end
      it "should redirect root page" do
        expect(response).to redirect_to(root_path)
      end
    end
    context "when account  sigend in is freelancer" do
      before do
         sign_in freelancer_account
         get :new ,params:{project_id:project,member_id:project_member}
      end
      it "should render new page" do
        expect(response).to render_template(:new)
      end
    end
  end

  describe "post /create" do
    context "when account not sigend in" do
      before do
         post :create ,params:{project_id:project,member_id:project_member,account_number:"1234567890",ifsc_code:"12345678901"}
      end
      it "should redirect sign in page" do
        expect(response).to redirect_to(new_account_session_path)
      end
    end
    context "when account  sigend in is client" do
      before do
         sign_in client_account
         post :create ,params:{project_id:project,member_id:project_member,account_number:"1234567890",ifsc_code:"12345678901"}
      end
      it "should redirect root page" do
        expect(response).to redirect_to(root_path)
      end
    end
    context "when account  sigend in is freelancer" do
      before do
         sign_in freelancer_account
         post :create ,params:{project_id:project,member_id:project_member,account_number:"1234567890",ifsc_code:"12345678901"}
      end
      it "should redirect root page" do
        expect(response).to redirect_to(new_feedback_path(to:project.client.account.id,from:project_member.memberable.account.id,member_id:project_member.id))

      end
    end
    context "when project_member is freelancer" do
      before do
         sign_in freelancer_account
         post :create ,params:{project_id:project,member_id:project_member1,account_number:"1234567890",ifsc_code:"12345678901"}
      end
      it "should redirect root page" do
        expect(response).to redirect_to(new_team_feedback_path(to:project.client.account.id,from:project_member1.memberable.admin.account.id,member_id:project_member1.id))

      end
    end
  end

end
