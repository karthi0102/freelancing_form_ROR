require 'rails_helper'

RSpec.describe "Feedbacks", type: :request do
  let!(:client) {create(:client)}
  let!(:client_account) {create(:account,:for_client,accountable:client)}

  let!(:freelancer) {create(:freelancer)}
  let!(:freelancer_account) {create(:account,:for_freelancer,accountable:freelancer)}

  let(:freelancer_token) {create(:doorkeeper_access_token,resource_owner_id:freelancer_account.id)}
  let(:client_token) {create(:doorkeeper_access_token,resource_owner_id:client_account.id)}
  let(:team) {create(:team,admin:freelancer)}
  let!(:project) {create(:project,client:client)}
  let(:project_member1){create(:project_member,memberable:freelancer,project:project)}
  let(:project_member2){create(:project_member,memberable:team,project:project)}
  describe "get/show" do
    context "when there is not access token" do
      before do
        get "/api/feedbacks"
      end
      it "should have http status 401" do
        expect(response).to have_http_status(401)
      end
    end
    context "when the user is client" do
      before do
        get "/api/feedbacks" ,params:{access_token:client_token.token}
      end
      it "should have http status 204" do
        expect(response).to have_http_status(204)
      end
    end
    context "when the user is client" do
      let(:feedback) {build(:feedback,created:freelancer_account,recipient:client_account)}
      before do
        feedback.save
        get "/api/feedbacks" ,params:{access_token:client_token.token}
      end
      it "should have http status 200" do
        expect(response).to have_http_status(200)
      end
    end
    context "when the user is freelancer" do
      before do
        get "/api/feedbacks" ,params:{access_token:freelancer_token.token}
      end
      it "should have http status 204" do
        expect(response).to have_http_status(204)
      end
    end
    context "when the user is freelancer" do
      let(:feedback) {build(:feedback,created:client_account,recipient:freelancer_account)}
      before do
        feedback.save
        get "/api/feedbacks" ,params:{access_token:freelancer_token.token}
      end
      it "should have http status 200" do
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "post/freelancer_to_client" do
    context "when there is not access token" do
      before do
        post "/api/feedback/freelancer/client" ,params:{feedback:{comment:"good good good goood",rating:4,to:client_account.id,from:freelancer_account.id,member_id:"nil"}}
      end
      it "should have http status 401" do
        expect(response).to have_http_status(401)
      end
    end
    context "when the user is client" do
      before do
        post "/api/feedback/freelancer/client" ,params:{feedback:{comment:"good good good goood",rating:4,to:client_account.id,from:freelancer_account.id,member_id:"nil"},access_token:client_token.token}
      end
      it "should have http status 401" do
        expect(response).to have_http_status(401)
      end
    end
    context "when the user is freelancer" do
      before do
        post "/api/feedback/freelancer/client" ,params:{feedback:{comment:"good good good goood",rating:4,to:client_account.id,from:freelancer_account.id,member_id:"nil"},access_token:freelancer_token.token}
      end
      it "should have http status 201" do
        expect(response).to have_http_status(201)
      end
    end
    context "when the user is freelancer but invalid params " do
      before do
        post "/api/feedback/freelancer/client" ,params:{feedback:{comment:"good good good goood",rating:14,to:client_account.id,from:freelancer_account.id,member_id:"nil"},access_token:freelancer_token.token}
      end
      it "should have http status 422" do
        expect(response).to have_http_status(422)
      end
    end
    context "when the user is freelancer but invalid params " do
      before do
        post "/api/feedback/freelancer/client" ,params:{feedback:{comment:"good good good goood",rating:14,to:"nil",from:freelancer_account.id,member_id:"nil"},access_token:freelancer_token.token}
      end
      it "should have http status 404" do
        expect(response).to have_http_status(404)
      end
    end
  end

  describe "post/team_to_client" do
    context "when there is not access token" do
      before do
        post "/api/feedback/team/client" ,params:{feedback:{comment:"good good good goood",rating:4,to:client_account.id,from:team.id,member_id:"nil"}}
      end
      it "should have http status 401" do
        expect(response).to have_http_status(401)
      end
    end
    context "when the user is client" do
      before do
        post "/api/feedback/team/client" ,params:{feedback:{comment:"good good good goood",rating:4,to:client_account.id,from:team.id,member_id:"nil"},access_token:client_token.token}
      end
      it "should have http status 401" do
        expect(response).to have_http_status(401)
      end
    end
    context "when the user is freelancer" do
      before do
        post "/api/feedback/team/client" ,params:{feedback:{comment:"good good good goood",rating:4,to:client_account.id,from:team.id,member_id:"nil"},access_token:freelancer_token.token}
      end
      it "should have http status 201" do
        expect(response).to have_http_status(201)
      end
    end
    context "when the user is freelancer but invalid params " do
      before do
        post "/api/feedback/team/client" ,params:{feedback:{comment:"good good good goood",rating:14,to:client_account.id,from:team.id,member_id:"nil"},access_token:freelancer_token.token}
      end
      it "should have http status 422" do
        expect(response).to have_http_status(422)
      end
    end
    context "when the user is freelancer but invalid params " do
      before do
        post "/api/feedback/freelancer/client" ,params:{feedback:{comment:"good good good goood",rating:14,to:"nil",from:team.id,member_id:"nil"},access_token:freelancer_token.token}
      end
      it "should have http status 404" do
        expect(response).to have_http_status(404)
      end
    end
  end


  describe "post/client_to_freelancer" do
    context "when there is not access token" do
      before do
        post "/api/feedback/client/freelancer" ,params:{feedback:{comment:"good good good goood",rating:4,to:freelancer_account.id,from:client_account.id,member_id:project_member1.id}}
      end
      it "should have http status 401" do
        expect(response).to have_http_status(401)
      end
    end
    context "when the user is freelancer" do
      before do
        post "/api/feedback/client/freelancer" ,params:{access_token:freelancer_token.token,feedback:{comment:"good good good goood",rating:4,to:freelancer_account.id,from:client_account.id,member_id:project_member1.id}}
      end
      it "should have http status 401" do
        expect(response).to have_http_status(401)
      end
    end
    context "when the user is client" do
      before do
        post "/api/feedback/client/freelancer" ,params:{access_token:client_token.token,feedback:{comment:"good good good goood",rating:4,to:freelancer_account.id,from:client_account.id,member_id:project_member1.id}}
      end
      it "should have http status 201" do
        expect(response).to have_http_status(201)
      end
    end
    context "when the user is client but invalid params " do
      before do
        post "/api/feedback/client/freelancer" ,params:{access_token:client_token.token,feedback:{comment:"good good good goood",rating:14,to:freelancer_account.id,from:client_account.id,member_id:project_member1.id}}
        end
      it "should have http status 422" do
        expect(response).to have_http_status(422)
      end
    end
    context "when the user is freelancer but invalid params " do
      before do
        post "/api/feedback/client/freelancer" ,params:{access_token:client_token.token,feedback:{comment:"good good good goood",rating:4,to:"nil",from:client_account.id,member_id:project_member1.id}}
       end
      it "should have http status 404" do
        expect(response).to have_http_status(404)
      end
    end
  end


  describe "post/cliet_to_team" do
    context "when there is not access token" do
      before do
        post "/api/feedback/client/team" ,params:{feedback:{comment:"good good good goood",rating:4,to:team.id,from:client_account.id,member_id:project_member1.id}}
      end
      it "should have http status 401" do
        expect(response).to have_http_status(401)
      end
    end
    context "when the user is freelancer" do
      before do
        post "/api/feedback/client/team" ,params:{access_token:freelancer_token.token,feedback:{comment:"good good good goood",rating:4,to:team.id,from:client_account.id,member_id:project_member1.id}}
      end
      it "should have http status 401" do
        expect(response).to have_http_status(401)
      end
    end
    context "when the user is client" do
      before do
        post "/api/feedback/client/team" ,params:{access_token:client_token.token,feedback:{comment:"good good good goood",rating:4,to:team.id,from:client_account.id,member_id:project_member1.id}}
      end
      it "should have http status 201" do
        expect(response).to have_http_status(201)
      end
    end

    context "when the user is client but invalid params " do
      before do
        post "/api/feedback/client/team" ,params:{access_token:client_token.token,feedback:{comment:"good good good goood",rating:4,to:"nil",from:client_account.id,member_id:project_member1.id}}
       end
      it "should have http status 404" do
        expect(response).to have_http_status(404)
      end
    end
  end


end
