require 'rails_helper'

RSpec.describe "BankAccountDetails", type: :request do
  let!(:freelancer) {create(:freelancer)}
  let!(:freelancer_account) {create(:account,:for_freelancer,accountable:freelancer)}

  let(:freelancer_token) { create(:doorkeeper_access_token , resource_owner_id: freelancer_account.id)}

  let!(:client) {create(:client)}
  let!(:client_account) {create(:account,:for_client,accountable:client)}

  let(:client_token) {create(:doorkeeper_access_token,resource_owner_id:client_account.id)}

  let!(:project){create(:project,client:client)}
  let!(:payment){create(:payment)}
  let!(:project_status){create(:project_status,project:project,payment:payment)}
  let(:project_member){create(:project_member,project:project,memberable:freelancer)}
  describe "patch #create" do
    context "when there is not access token" do
      before do
        patch "/api/account_details/new"
      end
      it "should have http status 401" do
        expect(response).to have_http_status(401)
      end
    end
    context "when the user is a client" do
      before do
        patch "/api/account_details/new" ,params:{access_token:client_token.token}
      end
      it "should have http status 401" do
        expect(response).to have_http_status(401)
      end
    end
    context "when the user is a freelancer" do
      before do
        patch "/api/account_details/new" ,params:{access_token:freelancer_token.token,project_id:project.id,member_id:project_member.id,account_number:"1234567890",ifsc_code:"12345678901"}
      end
      it "should have http status 201" do
        expect(response).to have_http_status(201)
      end
    end
    context "when the user is a freelancer and data is invalid" do
      before do
        patch "/api/account_details/new" ,params:{access_token:freelancer_token.token,project_id:project.id,member_id:project_member.id,account_number:"1234567890",ifsc_code:"1345678901"}
      end
      it "should have http status 422" do
        expect(response).to have_http_status(422)
      end
    end
    context "when the user is a freelancer and project is not found" do
      before do
        patch "/api/account_details/new" ,params:{access_token:freelancer_token.token,project_id:1,member_id:project_member.id,account_number:"1234567890",ifsc_code:"12345678901"}
      end
      it "should have http status 404" do
        expect(response).to have_http_status(404)
      end
    end
  end

end
