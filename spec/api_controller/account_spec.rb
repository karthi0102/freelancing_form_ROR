require 'rails_helper'

RSpec.describe Api::AccountController, type: :request do

  let!(:freelancer) {create(:freelancer)}
  let!(:freelancer_account) {create(:account,:for_freelancer,accountable:freelancer)}

  let(:freelancer_token) { create(:doorkeeper_access_token , resource_owner_id: freelancer_account.id)}
   describe "get /freelancers" do
    context "when user hits the api and there is no access token" do
      before do
        Freelancer.destroy_all
        get "/api/freelancers/all"
      end
      it "should render 401" do
        expect(response).to have_http_status(401)
      end
    end
      context "when user hits the api and there is no freelancer" do
        before do
          Freelancer.destroy_all
          get "/api/freelancers/all" ,params:{access_token:freelancer_token.token}
        end
        it "should render 204" do
          expect(response).to have_http_status(204)
        end
      end
      context "when user hits the api and there is freelancers" do
        before do
          get "/api/freelancers/all" ,params:{access_token:freelancer_token.token}
        end
        it "should render 200" do
          expect(response).to have_http_status(200)
        end
      end
   end
   describe "get /client" do
    context "when user hits the api and there is no access token" do
      before do
        Freelancer.destroy_all
        get "/api/clients/all"
      end
      it "should render 401" do
        expect(response).to have_http_status(401)
      end
    end
    context "when user hits the api and there is no client" do
      before do
        Client.destroy_all
        get "/api/clients/all" ,params:{access_token:freelancer_token.token}
      end
      it "should render 204" do
        expect(response).to have_http_status(204)
      end
    end
    context "when user hits the api and there is clients" do
      let(:client) {build(:client)}
      before do
        client.save
        get "/api/clients/all" ,params:{access_token:freelancer_token.token}
      end
      it "should render 200" do
        expect(response).to have_http_status(200)
      end
    end
 end
end


