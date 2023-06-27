require 'rails_helper'

RSpec.describe "Landings", type: :request do

  let!(:freelancer) {create(:freelancer)}
  let!(:freelancer_account) {create(:account,:for_freelancer,accountable:freelancer)}

  let(:freelancer_token) { create(:doorkeeper_access_token , resource_owner_id: freelancer_account.id)}

  describe "get/index" do
    context "when user hits the api and there is no access token" do
      before do
        get "/api/landing"
      end
      it "should render 401" do
        expect(response).to have_http_status(401)
      end
    end
    context "when user hits the api and there is  access token" do
      before do
        get "/api/landing" ,params:{access_token:freelancer_token.token}
      end
      it "should render 401" do
        expect(response).to have_http_status(200)
      end
    end
  end
end
