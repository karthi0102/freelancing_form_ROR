require 'rails_helper'

RSpec.describe FeedbackController, type: :controller do
  let(:client) {create(:client)}
  let(:client_account) {create(:account,:for_client,accountable:client)}

  let(:freelancer) {create(:freelancer)}
  let(:freelancer_account) {create(:account,:for_freelancer,accountable:freelancer)}

  let(:project) {create(:project,client:client)}
  let(:project_member) {create(:project_member,project:project,memberable:freelancer)}
  let(:team) {create(:team,admin:freelancer)}
  let(:team_project_member) {create(:project_member,project:project,memberable:team)}



  describe "get /feedback#new" do
    context "when user is not signed in" do
      before do
        get :new,params:{to:client_account,from:freelancer_account,member_id:project_member}
      end
      it "should redirect to signin page" do
        expect(response).to redirect_to(new_account_session_path)
      end
    end
    context "when feedback is from freelancer to client" do
      before do
        sign_in freelancer_account
        get :new,params:{to:client_account,from:freelancer_account,member_id:"nil"}
      end
      it "should render new page" do
        expect(response).to render_template(:new)
      end
    end
    context "when feedback is from team_admin to client" do
      before do
        sign_in freelancer_account
        get :new,params:{to:client_account,from:team.admin.account,member_id:"nil"}
      end
      it "should render new page" do
        expect(response).to render_template(:new)
      end
    end
    context "when feedback is from client to freelancer" do
      before do
        sign_in client_account
        get :new,params:{to:freelancer_account,from:client_account,member_id:project_member}
      end
      it "should render new page" do
        expect(response).to render_template(:new)
      end
    end
  end


  describe "get /feedback#team" do
    context "when user is not signed in" do
      before do
        get :new,params:{to:client_account,from:freelancer_account,member_id:project_member}
      end
      it "should redirect to signin page" do
        expect(response).to redirect_to(new_account_session_path)
      end
    end
    context "when feedback is from client_to_team" do
      before do
        sign_in client_account
        get :team ,params:{to:team,from:client.account,member_id:team_project_member}
      end
      it "should render team" do
        expect(response).to render_template(:team)
      end
    end
  end

  describe "post /feedback#team_create" do

    context "when user is not signed in" do
      before do

        post:team_create,params:{feedback:{to:team,from:freelancer_account,member_id:project_member,comment:"good freelancer has good skills",rating:3}}
      end
      it "should redirect to signin page" do
        expect(response).to redirect_to(new_account_session_path)
      end
    end
    context "when feedback id from client_to_team " do
      before do
        sign_in client_account
        post:team_create,params:{feedback:{to:team,from:client_account,member_id:project_member,comment:"good freelancer has good skills",rating:3}}
      end
      it "should redirect to signin page" do
        expect(response).to redirect_to(client_profile_path(client_account.accountable))
      end
    end
  end

  describe "post /create" do
    context "when user is not signed in" do
      before do
        get :new,params:{to:client_account,from:freelancer_account,member_id:project_member}
      end
      it "should redirect to signin page" do
        expect(response).to redirect_to(new_account_session_path)
      end
    end
    context "when feedback is from client_to_freelancer" do
      before do
        sign_in client_account
        post:create ,params:{feedback:{to:freelancer_account,from:client_account,member_id:project_member,comment:"good freelancer has good skills",rating:3}}
      end
      it "should return to client profile" do
        expect(response).to redirect_to (client_profile_path(client_account.accountable))
      end
    end
    context "when feedback is from freelancer_to_client" do
      before do
        sign_in freelancer_account
        post:create ,params:{feedback:{to:client_account,from:freelancer_account,member_id:"nil",comment:"good client has good skills",rating:3}}
      end
      it "should return to freelancer profile" do
        expect(response).to redirect_to (freelancer_profile_path(freelancer_account.accountable))
      end
    end
  end

end
