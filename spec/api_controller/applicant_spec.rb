require 'rails_helper'

RSpec.describe "Applicants", type: :request do
  let!(:client) {create(:client)}
  let!(:client_account) {create(:account,:for_client,accountable:client)}

  let!(:client1) {create(:client)}
  let!(:client_account1) {create(:account,:for_client,accountable:client1)}

  let!(:freelancer) {create(:freelancer)}
  let!(:freelancer_account) {create(:account,:for_freelancer,accountable:freelancer)}

  let(:freelancer_token) {create(:doorkeeper_access_token,resource_owner_id:freelancer_account.id)}

  let(:client_token) {create(:doorkeeper_access_token,resource_owner_id:client_account.id)}

  let(:client_token1) {create(:doorkeeper_access_token,resource_owner_id:client_account1.id)}

  let(:project) {create(:project,client:client)}
  let(:applicant) {create(:applicant,project:project,applicable:freelancer)}
  let(:team){create(:team)}

  describe "get/applicants" do
    context "when there is not access token" do
      before do
        get "/api/projects/#{project.id}/applicants"
      end
      it "should have http status 401" do
        expect(response).to have_http_status(401)
      end
    end
    context "when the user is freelancer" do
      before do
        get "/api/projects/#{project.id}/applicants",params:{access_token:freelancer_token.token}
      end
      it "should have http status 401" do
        expect(response).to have_http_status(401)
      end
    end
    context "when the user is client" do
      before do
        get "/api/projects/#{project.id}/applicants",params:{access_token:client_token.token}
      end
      it "should have http status 200" do
        expect(response).to have_http_status(200)
      end
    end
    context "when the user is other client" do
      before do
        get "/api/projects/#{project.id}/applicants",params:{access_token:client_token1.token}
      end
      it "should have http status 401" do
        expect(response).to have_http_status(401)
      end
    end
  end

  describe "get/freelancer_applicants" do
    context "when there is not access token" do
      before do
        get "/api/freelancer/applications"
      end
      it "should have http status 401" do
        expect(response).to have_http_status(401)
      end
    end
    context "when the user is client" do
      before do
        get "/api/freelancer/applications",params:{access_token:client_token.token}
      end
      it "should have http status 401" do
        expect(response).to have_http_status(401)
      end
    end
    context "when the user is freelancer" do
      before do
        get "/api/freelancer/applications",params:{access_token:freelancer_token.token}
      end
      it "should have http status 200" do
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "get/team_applicants" do
    context "when there is not access token" do
      before do
        get "/api/team/applications/#{team.id}"
      end
      it "should have http status 401" do
        expect(response).to have_http_status(401)
      end
    end
    context "when the user is client" do
      before do
        get "/api/team/applications/#{team.id}",params:{access_token:client_token.token}
      end
      it "should have http status 401" do
        expect(response).to have_http_status(401)
      end
    end
    context "when the user is freelancer" do
      before do
        get "/api/team/applications/#{team.id}",params:{access_token:freelancer_token.token}
      end
      it "should have http status 200" do
        expect(response).to have_http_status(200)
      end
    end
  end


  describe "post add_freelancer_applicant" do
    context "when there is not access token" do
      before do
        post "/api/project/apply/freelancer/#{project.id}"
      end
      it "should have http status 401" do
        expect(response).to have_http_status(401)
      end
    end
    context "when the user is client" do
      before do
        post "/api/project/apply/freelancer/#{project.id}",params:{access_token:client_token.token}
      end
      it "should have http status 401" do
        expect(response).to have_http_status(401)
      end
    end
    context "when the user is freelancer" do
      before do
        post "/api/project/apply/freelancer/#{project.id}",params:{access_token:freelancer_token.token}
      end
      it "should have http status 201" do
        expect(response).to have_http_status(201)
      end
    end
    context "when the user is freelancer but project not found" do
      before do
        post "/api/project/apply/freelancer/12",params:{access_token:freelancer_token.token}
      end
      it "should have http status 404" do
        expect(response).to have_http_status(404)
      end
    end
  end

  describe "post add_team_applicant" do
    context "when there is not access token" do
      before do
        post "/api/project/apply/team/#{project.id}/#{team.id}"
      end
      it "should have http status 401" do
        expect(response).to have_http_status(401)
      end
    end
    context "when the user is client" do
      before do
        post "/api/project/apply/team/#{project.id}/#{team.id}",params:{access_token:client_token.token}
      end
      it "should have http status 401" do
        expect(response).to have_http_status(401)
      end
    end
    context "when the user is freelancer" do
      before do
        post "/api/project/apply/team/#{project.id}/#{team.id}",params:{access_token:freelancer_token.token}
      end
      it "should have http status 201" do
        expect(response).to have_http_status(201)
      end
    end
    context "when the user is freelancer but project not found" do
      before do
        post "/api/project/apply/team/12/#{team.id}",params:{access_token:freelancer_token.token}
      end
      it "should have http status 404" do
        expect(response).to have_http_status(404)
      end
    end
  end

  describe "patch #reject" do
    context "when there is not access token" do
      before do
        patch "/api/project/applicant/reject/#{project.id}/#{applicant.id}"
      end
      it "should have http status 401" do
        expect(response).to have_http_status(401)
      end
    end
    context "when the user is freelancer" do
      before do
        patch "/api/project/applicant/reject/#{project.id}/#{applicant.id}" ,params:{access_token:freelancer_token.token}
      end
      it "should have http status 401" do
        expect(response).to have_http_status(401)
      end
    end
    context "when the user is client" do
      before do
        patch "/api/project/applicant/reject/#{project.id}/#{applicant.id}" ,params:{access_token:client_token.token}
      end
      it "should have http status 200" do
        expect(response).to have_http_status(200)
      end
    end
    context "when the user is client but no project id" do
      before do
        patch "/api/project/applicant/reject/abc/#{applicant.id}" ,params:{access_token:client_token.token}
      end
      it "should have http status 404" do
        expect(response).to have_http_status(404)
      end
    end
    context "when the user is other client" do
      before do
        patch "/api/project/applicant/reject/#{project.id}/#{applicant.id}" ,params:{access_token:client_token1.token}
      end
      it "should have http status 401" do
        expect(response).to have_http_status(401)
      end
    end
  end


end
