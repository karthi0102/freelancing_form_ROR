require 'rails_helper'

RSpec.describe Api::SkillsController, type: :request do
  let!(:client) {create(:client)}
  let!(:client_account) {create(:account,:for_client,accountable:client)}


  let!(:freelancer) {create(:freelancer)}
  let!(:freelancer_account) {create(:account,:for_freelancer,accountable:freelancer)}

  let!(:freelancer1) {create(:freelancer)}
  let!(:freelancer_account1) {create(:account,:for_freelancer,accountable:freelancer1)}

  let(:freelancer_token) {create(:doorkeeper_access_token,resource_owner_id:freelancer_account.id)}
  let(:freelancer_token1) {create(:doorkeeper_access_token,resource_owner_id:freelancer_account1.id)}
  let(:client_token) {create(:doorkeeper_access_token,resource_owner_id:client_account.id)}
  let(:skill) {create(:skill,freelancer:freelancer)}

  describe "get/show" do
    context "when there is not access token" do
      before do
        get "/api/skills/"
      end
      it "should have http status 401" do
        expect(response).to have_http_status(401)
      end
    end
    context "when the user is client" do
      before do
        get "/api/skills/" ,params:{access_token:client_token.token}
      end
      it "should have http status 401" do
        expect(response).to have_http_status(401)
      end
    end
    context "when the user is freelancer" do
      let(:skill) {build(:skill,freelancer:freelancer)}
      before do
        skill.save
        get "/api/skills/" ,params:{access_token:freelancer_token.token}
      end
      it "should have http status 200" do
        expect(response).to have_http_status(200)
      end
    end
  end


  describe "post/create" do
    context "when there is not access token" do
      before do
        post "/api/skills/" ,params:{skill:{name:"C",level:"Beginner"}}
      end
      it "should have http status 401" do
        expect(response).to have_http_status(401)
      end
    end
    context "when the user is client" do
      before do
        post "/api/skills/" ,params:{access_token:client_token.token,skill:{name:"C",level:"Beginner"}}
      end
      it "should have http status 401" do
        expect(response).to have_http_status(401)
      end
    end
    context "when the user is freelancer" do

      before do
        post "/api/skills/" ,params:{skill:{name:"C",level:"Beginner"},access_token:freelancer_token.token}
      end
      it "should have http status 201" do
        expect(response).to have_http_status(201)
      end
    end
    context "when the user is freelancer but invalid params" do

      before do
        post "/api/skills/" ,params:{skill:{name:nil,level:"Beginner"},access_token:freelancer_token.token}
      end
      it "should have http status 417" do
        expect(response).to have_http_status(417)
      end
    end
  end

  describe "delete/destroy" do
    context "when there is not access token" do
      before do
        delete "/api/skills/#{skill.id}"
      end
      it "should have http status 401" do
        expect(response).to have_http_status(401)
      end
    end
    context "when the user is client" do
      before do
        delete "/api/skills/#{skill.id}" ,params:{access_token:client_token.token}
      end
      it "should have http status 401" do
        expect(response).to have_http_status(401)
      end
    end
    context "when the user is freelancer" do
      before do
        delete "/api/skills/#{skill.id}" ,params:{access_token:freelancer_token.token}
      end
      it "should have http status 303" do
        expect(response).to have_http_status(303)
      end
    end
    context "when the user is other freelancer" do
      before do
        delete "/api/skills/#{skill.id}" ,params:{access_token:freelancer_token1.token}
      end
      it "should have http status 401" do
        expect(response).to have_http_status(422)
      end
    end


  end

end
