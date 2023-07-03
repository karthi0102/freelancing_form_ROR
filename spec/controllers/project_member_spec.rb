require 'rails_helper'

RSpec.describe ProjectMemberController, type: :controller do
  let(:client) {create(:client)}
  let(:client_account) {create(:account,:for_client,accountable:client)}

  let(:client1) {create(:client)}
  let(:client_account1) {create(:account,:for_client,accountable:client1)}

  let(:freelancer) {create(:freelancer)}
  let(:freelancer_account) {create(:account,:for_freelancer,accountable:freelancer)}

  let(:project) {create(:project,client:client)}
  let(:applicant) {create(:applicant,project:project,applicable:freelancer)}
  let(:project_member) {create(:project_member,memberable:freelancer)}

  let(:team) {create(:team)}

  describe "post /project_member#accept" do
    context "when user is not signed in" do
      before do
        post :accept ,params:{project_id:project,applicant_id:applicant}
      end
      it "should redirect to signin page" do
        expect(response).to redirect_to(new_account_session_path)
      end
    end
    context "when user is freelancer" do
      before do
        sign_in freelancer_account
        post :accept ,params:{project_id:project,applicant_id:applicant}
      end
      it "should redirect to projects page" do
        expect(response).to redirect_to(projects_path)
      end
    end
    context "when user is client" do
      before do
        sign_in client_account
        post :accept ,params:{project_id:project,applicant_id:applicant}
      end
      it "should be eq to accepted " do
        expect(flash[:notice]).to eq("Accepted")
      end
    end
    context "when user is client and project_is_invalid" do
      before do
        sign_in client_account
        post :accept ,params:{project_id:"nil",applicant_id:applicant}
      end
      it "should redirect to root page" do
        expect(response).to redirect_to(root_path)
      end
    end

    context "when user is other client" do
      before do
        sign_in client_account1
        post :accept ,params:{project_id:project,applicant_id:applicant}
      end
      it "should redirect to root page" do
        expect(response).to redirect_to(root_path)
      end
    end
  end

end
