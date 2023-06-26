require 'rails_helper'

RSpec.describe TeamsController, type: :controller do

  let(:client) {create(:client)}
  let(:client_account) {create(:account,:for_client,accountable:client)}

  let(:freelancer) {create(:freelancer)}
  let(:freelancer_account) {create(:account,:for_freelancer,accountable:freelancer)}

  let(:freelancer1) {create(:freelancer)}
  let(:freelancer_account1) {create(:account,:for_freelancer,accountable:freelancer1)}

  let(:team) {create(:team,admin:freelancer)}

  describe "get '/teams#index" do
    context "when user is not signed in" do
      before do
        get :index
      end
      it "should redirect to signin page" do
        expect(response).to redirect_to(new_account_session_path)
      end
    end
    context "when user is a client" do
      before do
        sign_in client_account
        get :index
      end
      it "should redirect to rootpath" do
        expect(response).to redirect_to(root_path)
      end
    end
    context "when user is a freelancer" do
      before do
        sign_in freelancer_account
        get :index
      end
      it "should render index" do
        expect(response).to render_template(:index)
      end
    end
  end
  describe "get /teams#show" do
    context "when user is not signed in" do
      before do
        get :show,params: {id:team.id}
      end
      it "should redirect to signin page" do
        expect(response).to redirect_to(new_account_session_path)
      end
    end
    context "when user is signed in" do
      before do
        sign_in freelancer_account
        get :show ,params: {id:team.id}
      end
      it "should render show" do
        expect(response).to render_template(:show)
      end
    end
    context "when user is signed in but invalid params" do
      before do
        sign_in freelancer_account
        get :show ,params: {id:'12'}
      end
      it "should redirect to root_path" do
        expect(response).to redirect_to (root_path)
      end
    end
  end

  describe "get '/teams#new" do
    context "when user is not signed in" do
      before do
       get :new
      end
      it "should redirect to signin page" do
        expect(response).to redirect_to(new_account_session_path)
      end
    end
    context "when user is signed in as client" do
      before do
       sign_in client_account
       get :new
      end
      it "should redirect to root_path" do
        expect(response).to redirect_to(root_path)
      end
    end
    context "when user is signed in as freelancer" do
      before do
       sign_in freelancer_account
       get :new
      end
      it "should render new" do
        expect(response).to render_template(:new)
      end
    end
  end

  describe "post /teams#create" do
    context "when user is not signed in" do
      before do
       post :create ,params:{team:{name:team.name,description:team.description}}
      end
      it "should redirect to signin page" do
        expect(response).to redirect_to(new_account_session_path)
      end
    end
    context "when user is signed in as client" do
      before do
       sign_in client_account
       post :create ,params:{team:{name:team.name,description:team.description}}
      end
      it "should redirect to root_path" do
        expect(response).to redirect_to(root_path)
      end
    end
    context "when user is signed in as freelancer" do
      before do
       sign_in freelancer_account
       post :create ,params:{team:{name:team.name,description:team.description,admin:freelancer}}
      end
      it "should contain flash" do
        expect(flash[:notice]).to eq("Created New Team")
      end
    end
  end

  describe "get /teams#edit" do
    context "when user is not signed in" do
      before do
       get :edit ,params:{id:team.id}
      end
      it "should redirect to signin page" do
        expect(response).to redirect_to(new_account_session_path)
      end
    end
    context "when user is signed in as client" do
      before do
       sign_in client_account
       get :edit ,params:{id:team.id}
      end
      it "should redirect to root_path" do
        expect(response).to redirect_to(root_path)
      end
    end
    context "when user is signed in as freelancer" do
      before do
       sign_in freelancer_account
       get :edit ,params:{id:team.id}
      end
      it "should render edit" do
        expect(response).to render_template(:edit)
      end
    end
    context "when user is signed in as other freelancer" do
      before do
       sign_in freelancer_account1
       get :edit ,params:{id:team.id}
      end
      it "should render edit" do
        expect(flash[:error]).to eq("Unauthorized action")
      end
    end
  end

  describe "patch /teams#update" do
    context "when user is not signed in" do
      before do
       patch:update , params:{id:team.id,team:{name:"rspec testing"}}
      end
      it "should redirect to signin page" do
        expect(response).to redirect_to(new_account_session_path)
      end
    end
    context "when user is signed in as client" do
      before do
       sign_in client_account
       patch:update , params:{id:team.id,team:{name:"rspec testing"}}
      end
      it "should redirect to root_path" do
        expect(response).to redirect_to(root_path)
      end
    end
    context "when user is signed in as freelancer" do
      before do
       sign_in freelancer_account
       patch:update , params:{id:team.id,team:{name:"rspec testing"}}
      end
      it "should redirect_to team path" do
        expect(response).to redirect_to(team_path(team.id))
      end
    end
    context "when user is signed in as other freelancer" do
      before do
       sign_in freelancer_account1
       patch:update , params:{id:team.id,team:{name:"rspec testing"}}
      end
      it "should render edit" do
        expect(flash[:error]).to eq("Unauthorized action")
      end
    end
  end


  describe "delete /teams#destory" do
    context "when user is not signed in" do
      before do
       delete:destroy ,params:{id:team.id}
      end
      it "should redirect to signin page" do
        expect(response).to redirect_to(new_account_session_path)
      end
    end
    context "when user is signed in as client" do
      before do
       sign_in client_account
       delete:destroy ,params:{id:team.id}
      end
      it "should redirect to root_path" do
        expect(response).to redirect_to(root_path)
      end
    end
    context "when user is signed in as freelancer" do
      before do
       sign_in freelancer_account
       delete:destroy ,params:{id:team.id}
      end
      it "should redirect_to team path" do
        expect(response).to redirect_to(teams_path)
      end
    end
    context "when user is signed in as other freelancer" do
      before do
       sign_in freelancer_account1
       delete:destroy ,params:{id:team.id}
      end
      it "should render edit" do
        expect(flash[:error]).to eq("Unauthorized action")
      end
    end
  end

  describe "post /teams#join" do
    context "when user is not signed in" do
      before do
          post :join,params:{team_id:team.id}
      end
      it "should redirect to signin page" do
        expect(response).to redirect_to(new_account_session_path)
      end
    end
    context "when user is signed in as client" do
      before do
       sign_in client_account
       post :join,params:{team_id:team.id}
      end
      it "should redirect to root_path" do
        expect(response).to redirect_to(root_path)
      end
    end

    context "when user is signed in as  freelancer" do
      before do
       sign_in freelancer_account1
       post :join,params:{team_id:team.id}
      end
      it "should render edit" do
        expect(flash[:notice]).to eq("Joined in a team")
      end
    end
  end

  describe "post 'teams#remove" do
    context "when user is not signed in" do
      before do
          post :remove,params:{id:team.id,freelancer_id:freelancer.id}
      end
      it "should redirect to signin page" do
        expect(response).to redirect_to(new_account_session_path)
      end
    end
    context "when user is signed in as client" do
      before do
       sign_in client_account
       post :remove,params:{id:team.id,freelancer_id:freelancer.id}
      end
      it "should redirect to root_path" do
        expect(response).to redirect_to(root_path)
      end
    end
    context "when user is signed in as freelancer" do
      before do
       sign_in freelancer_account
       post :remove,params:{id:team.id,freelancer_id:freelancer1.id}
      end
      it "should redirect to team path" do
        expect(response).to redirect_to(team_path(team.id))
      end
    end
    context "when user is signed in as other freelancer" do
      before do
       sign_in freelancer_account1
       post :remove,params:{id:team.id,freelancer_id:freelancer1.id}
      end
      it "should redirect to root_path" do
        expect(response).to redirect_to(root_path)
      end
    end

  end

end
