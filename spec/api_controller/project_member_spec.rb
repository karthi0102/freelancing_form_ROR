require 'rails_helper'

RSpec.describe Api::ProjectMemberController, type: :request do
  let!(:client) {create(:client)}
  let!(:client_account) {create(:account,:for_client,accountable:client)}

  let!(:client1) {create(:client)}
  let!(:client_account1) {create(:account,:for_client,accountable:client1)}

  let!(:freelancer) {create(:freelancer)}
  let!(:freelancer_account) {create(:account,:for_freelancer,accountable:freelancer)}

  let!(:freelancer1) {create(:freelancer)}
  let!(:freelancer_account1) {create(:account,:for_freelancer,accountable:freelancer1)}

  let(:freelancer_token) {create(:doorkeeper_access_token,resource_owner_id:freelancer_account.id)}
  let(:freelancer_token1) {create(:doorkeeper_access_token,resource_owner_id:freelancer_account1.id)}
  let(:client_token) {create(:doorkeeper_access_token,resource_owner_id:client_account.id)}
  let(:client_token1) {create(:doorkeeper_access_token,resource_owner_id:client_account1.id)}

  let!(:project) {create(:project,client:client)}
  let!(:project_status) {create(:project_status,project:project)}
  let!(:applicant) {create(:applicant,project:project,applicable:freelancer)}
  let!(:project_member) {create(:project_member,project:project,memberable:freelancer)}

  describe "get/show" do
    context "when there is not access token" do
      before do
        get "/api/project/#{project.id}/members"
      end
      it "should have http status 401" do
        expect(response).to have_http_status(401)
      end
    end
    context "when the user is freelancer" do
      before do
        get "/api/project/#{project.id}/members" ,params:{access_token:freelancer_token.token}
      end
      it "should have http status 401" do
        expect(response).to have_http_status(401)
      end
    end
    context "when the user is client" do
      before do
        get "/api/project/#{project.id}/members" ,params:{access_token:client_token.token}
      end
      it "should have http status 200" do
        expect(response).to have_http_status(200)
      end
    end
    context "when the user is other client" do
      before do
        get "/api/project/#{project.id}/members" ,params:{access_token:client_token1.token}
      end
      it "should have http status 401" do
        expect(response).to have_http_status(401)
      end
    end
    context "when the user is client and have no  members" do
      before do
        ProjectMember.destroy_all
        get "/api/project/#{project.id}/members" ,params:{access_token:client_token.token}
      end
      it "should have http status 204" do
        expect(response).to have_http_status(204)
      end
    end

  end

  describe "patch #accept" do
    context "when there is not access token" do
      before do
        patch "/api/project/applicant/accept/#{project.id}/#{applicant.id}"
      end
      it "should have http status 401" do
        expect(response).to have_http_status(401)
      end
    end
    context "when the user is freelancer" do
      before do
        patch "/api/project/applicant/accept/#{project.id}/#{applicant.id}" ,params:{access_token:freelancer_token.token}
      end
      it "should have http status 401" do
        expect(response).to have_http_status(401)
      end
    end
    context "when the user is client" do
      before do
        patch "/api/project/applicant/accept/#{project.id}/#{applicant.id}" ,params:{access_token:client_token.token}
      end
      it "should have http status 200" do
        expect(response).to have_http_status(200)
      end
    end
    context "when the user is client but no project id" do
      before do
        patch "/api/project/applicant/accept/abc/#{applicant.id}" ,params:{access_token:client_token.token}
      end
      it "should have http status 404" do
        expect(response).to have_http_status(404)
      end
    end
    context "when the user is other client" do
      before do
        patch "/api/project/applicant/accept/#{project.id}/#{applicant.id}" ,params:{access_token:client_token1.token}
      end
      it "should have http status 401" do
        expect(response).to have_http_status(401)
      end
    end
  end


  describe "patch/completed" do
    context "when there is not access token" do
      before do
        patch "/api/project_member/change_status/#{project.id}/#{project_member.id}"
      end
      it "should have http status 401" do
        expect(response).to have_http_status(401)
      end
    end
    context "when the user is client" do
      before do
        patch "/api/project_member/change_status/#{project.id}/#{project_member.id}",params:{access_token:client_token.token}
      end
      it "should have http status 401" do
        expect(response).to have_http_status(401)
      end
    end
    context "when the user is freelancer" do
      before do
        patch "/api/project_member/change_status/#{project.id}/#{project_member.id}",params:{access_token:freelancer_token.token}
      end
      it "should have http status 200" do
        expect(response).to have_http_status(200)
      end
    end
    context "when the user is other freelancer" do
      before do
        patch "/api/project_member/change_status/#{project.id}/#{project_member.id}",params:{access_token:freelancer_token1.token}
      end
      it "should have http status 400" do
        expect(response).to have_http_status(401)
      end
    end
  end

end
