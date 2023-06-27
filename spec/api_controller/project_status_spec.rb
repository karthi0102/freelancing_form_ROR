require 'rails_helper'

RSpec.describe Api::ProjectStatusController, type: :request do
  let!(:client) {create(:client)}
  let!(:client_account) {create(:account,:for_client,accountable:client)}

  let!(:client1) {create(:client)}
  let!(:client_account1) {create(:account,:for_client,accountable:client1)}

  let!(:freelancer) {create(:freelancer)}
  let!(:freelancer_account) {create(:account,:for_freelancer,accountable:freelancer)}

  let(:freelancer_token) {create(:doorkeeper_access_token,resource_owner_id:freelancer_account.id)}
  let(:client_token) {create(:doorkeeper_access_token,resource_owner_id:client_account.id)}
  let(:client_token1) {create(:doorkeeper_access_token,resource_owner_id:client_account1.id)}
  let!(:project) {create(:project,client:client)}
  let(:project_status) {build(:project_status,project:project)}

  describe "get/show" do
    context "when there is not access token" do
      before do
        get "/api/project/#{project.id}/status"
      end
      it "should have http status 401" do
        expect(response).to have_http_status(401)
      end
    end
    context "when the user is freelancer" do
      before do
        get "/api/project/#{project.id}/status",params:{access_token:freelancer_token.token}
      end
      it "should have http status 401" do
        expect(response).to have_http_status(401)
      end
    end
    context "when the user is client but dont have project status" do
      before do
        get "/api/project/#{project.id}/status",params:{access_token:client_token.token}
      end
      it "should have http status 204" do
        expect(response).to have_http_status(204)
      end
    end
    context "when the user is client " do
      before do
        project_status.save
        get "/api/project/#{project.id}/status",params:{access_token:client_token.token}
      end
      it "should have http status 200" do
        expect(response).to have_http_status(200)
      end
    end
    context "when the user is other client " do
      before do
        project_status.save
        get "/api/project/#{project.id}/status",params:{access_token:client_token1.token}
      end
      it "should have http status 401" do
        expect(response).to have_http_status(401)
      end
    end
  end

end
