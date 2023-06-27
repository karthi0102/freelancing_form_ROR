require 'rails_helper'

RSpec.describe Api::ProfileController, type: :request do
  let!(:freelancer) {create(:freelancer)}
  let!(:freelancer_account) {create(:account,:for_freelancer,accountable:freelancer)}

  let!(:client) {create(:client)}
  let!(:client_account) {create(:account,:for_client,accountable:client)}
  let(:freelancer_token) {create(:doorkeeper_access_token,resource_owner_id:freelancer_account.id)}

  describe "get/freelancer" do
    context "when there is not access token" do
      before do
        get "/api/profile/freelancer/#{freelancer.id}"
      end
      it "should have http status 401" do
        expect(response).to have_http_status(401)
      end
    end
    context "when there is  access token" do
      before do
        get "/api/profile/freelancer/#{freelancer.id}" ,params:{access_token:freelancer_token.token}
      end
      it "should have http status 200" do
        expect(response).to have_http_status(200)
      end
    end
    context "when there is no profile" do
      before do
        get "/api/profile/freelancer/10" ,params:{access_token:freelancer_token.token}
      end
      it "should have http status 404" do
        expect(response).to have_http_status(404)
      end
    end
  end
  describe "get/client" do
    context "when there is not access token" do
      before do
        get "/api/profile/client/#{client.id}"
      end
      it "should have http status 401" do
        expect(response).to have_http_status(401)
      end
    end
    context "when there is  access token" do
      before do
        get "/api/profile/client/#{client.id}" ,params:{access_token:freelancer_token.token}
      end
      it "should have http status 200" do
        expect(response).to have_http_status(200)
      end
    end
    context "when there is no profile"do
      before do
        get "/api/profile/client/1" ,params:{access_token:freelancer_token.token}
      end
      it "should have http status 404" do
        expect(response).to have_http_status(404)
      end
    end
  end
end
