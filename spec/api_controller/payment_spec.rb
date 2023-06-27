require 'rails_helper'

RSpec.describe "Payments", type: :request do
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
  let!(:payment){create(:payment)}
  let!(:project_status) {create(:project_status,project:project,payment:payment)}
  let(:project_member) {create(:project_member,project:project,memberable:freelancer)}

  describe "get/show" do
      context "when there is not access token" do
        before do
          get "/api/project/#{project.id}/payment"
        end
        it "should have http status 401" do
          expect(response).to have_http_status(401)
        end
      end
      context "when the user is freelancer" do
        before do
          get "/api/project/#{project.id}/payment" ,params:{access_token:freelancer_token.token}
        end
        it "should have http status 401" do
          expect(response).to have_http_status(401)
        end
      end
    context "when the user is client" do
      before do
        get "/api/project/#{project.id}/payment" ,params:{access_token:client_token.token}
      end
      it "should have http status 200" do
        expect(response).to have_http_status(200)
      end
    end
    context "when the user is other client" do
      before do
        get "/api/project/#{project.id}/payment" ,params:{access_token:client_token1.token}
      end
      it "should have http status 401" do
        expect(response).to have_http_status(401)
      end
    end
    context "when the user is client but project not found" do
      before do
        get "/api/project/11/payment" ,params:{access_token:client_token.token}
      end
      it "should have http status 404" do
        expect(response).to have_http_status(404)
      end
    end
  end

  describe "post #create" do
    context "when there is not access token" do
      before do
        patch "/api/project_member/payment"
      end
      it "should have http status 401" do
        expect(response).to have_http_status(401)
      end
    end
    context "when the user is freelancer" do
      before do
        patch "/api/project_member/payment" ,params:{access_token:freelancer_token.token}
      end
      it "should have http status 401" do
        expect(response).to have_http_status(401)
      end
    end
    context "when the user is client" do
      before do
        patch "/api/project_member/payment" ,params:{access_token:client_token.token,project_id:project.id,member_id:project_member.id,card_number:"12345678901","card_expiry":"12/2024",card_cvv:123,amount:1000,}
      end
      it "should have http status 201" do
        expect(response).to have_http_status(201)
      end
    end
    context "when the user is other client" do
      before do
        patch "/api/project_member/payment" ,params:{access_token:client_token1.token,project_id:project.id,member_id:project_member.id,card_number:"12345678901","card_expiry":"12/2024",card_cvv:123,amount:1000,}
      end
      it "should have http status 401" do
        expect(response).to have_http_status(401)
      end
    end
    context "when the user is client but invalid params" do
      before do
        patch "/api/project_member/payment" ,params:{access_token:client_token1.token,project_id:"1",member_id:project_member.id,card_number:"12345678901","card_expiry":"12/2024",card_cvv:123,amount:1000,}
      end
      it "should have http status 404" do
        expect(response).to have_http_status(404)
      end
    end
  end

end
