require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do

  let(:client) {create(:client)}
  let(:client_account) {create(:account,:for_client,accountable:client)}

  let(:client1) {create(:client)}
  let(:client_account1) {create(:account,:for_client,accountable:client1)}

  let(:freelancer) {create(:freelancer)}
  let(:freelancer_account) {create(:account,:for_freelancer,accountable:freelancer)}

  let(:project) {create(:project,client:client)}



  describe "get /projects#new" do

    context "when account not sigend it" do
      before do
         get :new
      end
      it "should redirect sign in page" do
        expect(response).to redirect_to(new_account_session_path)
      end
    end

    context "when account is sigend as freelancer" do
      before do
         sign_in freelancer_account
         get :new
      end
      it "should redirect to projects_path" do
        expect(response).to redirect_to(projects_path)
      end
    end

    context "when account is sigend as client" do
      before do
         sign_in client_account
         get :new
      end
      it "should render new" do
        expect(response).to render_template(:new)
      end
    end

  end


  describe "get project/index" do

    context "when account not sigend it" do
      before do
         get :index
      end
      it "should redirect sign in page" do
        expect(response).to redirect_to(new_account_session_path)
      end
    end

    context "when account signed in as freelancer" do
      before do
        sign_in freelancer_account
        get :index
      end
      it "should render template" do
        expect(response).to render_template(:index)
      end
    end


    context "when account signed in as client" do
      before do
        sign_in client_account
        get :index
      end
      it "should redirect to root_path" do
        expect(response).to redirect_to(root_path)
      end
    end

  end



  describe "get /projects#show" do

    context "when account is not signed in" do
      before do
        get :show ,params: {id:project.id}
      end
      it "should redirect to sign in path" do
        expect(response).to redirect_to(new_account_session_path)
      end
    end
    context "when account is  signed in" do
      before do
        sign_in freelancer_account
        get :show ,params: {id:project.id}
      end
      it "should redirect to sign in path" do
        expect(response).to render_template(:show)
      end
    end
    context "when account is  signed in and params is invalid" do
      before do
        sign_in freelancer_account
        get :show ,params: {id:'a'}
      end
      it "should redirect to root_path" do
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "post /projects#create" do
      context "when account is signed in" do
        before do
          post :create
        end
        it "should redirect to sign_in_path" do
          expect(response).to redirect_to(new_account_session_path)
        end
      end
      context "when account is signed in freeelancer" do
        before do
          sign_in freelancer_account
          post :create
        end
        it "should redirect to projects_path" do
          expect(response).to redirect_to(projects_path)
        end
      end

      context "when account is signed in client" do
        before do
          sign_in client_account
          post :create ,params: {project:{name:project.name,description:project.description,amount:6000,client:client}}
        end
        it "should render create" do
          expect(flash[:notice]).to eq("Created New Project")
        end
      end

      context "when account is signed in client with invalid params" do
        before do
          sign_in client_account
          post :create ,params: {project:{name:project.name,description:project.description,amount:nil,client:client}}
        end
        it "should create new projects" do
          expect(response).to render_template(:new)
        end
      end

      context "when account is signed in client with invalid params" do
        before do
          sign_in client_account
          post :create ,params: {project:{name:project.name,description:project.description,amount:nil,client:client}}
        end
        it "should render new" do
          expect(response).to render_template(:new)
        end
      end

  end

  describe "get projects/edit" do
    context "when account is not signed in" do
      before do
        get :edit ,params: {id:project.id}
      end
      it "should redirect to sign in path" do
        expect(response).to redirect_to(new_account_session_path)
      end
    end

    context "when account is signed in as freelancer" do
      before do
        sign_in freelancer_account
        get :edit ,params: {id:project.id}
      end
      it "should redirect to projects path" do
        expect(response).to redirect_to(projects_path)
      end
    end

    context "when account is signed in as client" do
      before do
        sign_in client_account
        get :edit ,params: {id:project.id}
      end
      it "should render edit" do
        expect(response).to render_template(:edit)
      end
    end

    context "when account is signed in as client and params is invalid" do
      before do
        sign_in client_account
        get :edit ,params: {id:'a'}
      end
      it "should redirect to root" do
        expect(response).to redirect_to(root_path)
      end
    end

    context "when account is signed in as other client " do
      before do
        sign_in client_account1
        get :edit ,params: {id:project.id}
      end
      it "should redirect to root" do
        expect(response).to redirect_to(root_path)
      end
    end

  end


  describe "patch /projects/update" do
    context "when account is not signed in" do
      before do
        patch :update ,params: {id:project.id}
      end
      it "should redirect to sign in path" do
        expect(response).to redirect_to(new_account_session_path)
      end
    end
    context "when account is signed in as freelancer" do
      before do
        sign_in freelancer_account
        patch:update ,params: {id:project.id}
      end
      it "should redirect to projects path" do
        expect(response).to redirect_to(projects_path)
      end
    end

    context "when account is signed in as client" do
      before do
        sign_in client_account
        patch:update ,params: {id:project.id,project:{name:"RSPEC CONTROller"}}
      end
      it "should redirect to projects path" do
        expect(response).to redirect_to((project_path(project.id)))
      end
    end

    context "when account is signed in as other client" do
      before do
        sign_in client_account1
        patch:update ,params: {id:project.id,project:{name:"RSPEC CONTROller"}}
      end
      it "should redirect to projects path" do
        expect(response).to redirect_to(root_path)
      end
    end

  end

  describe "delete /projects#destory" do
    context "when account is not signed in" do
      before do
         delete:destroy ,params:{id:project.id}
      end
      it "should redirect to sign in path" do
        expect(response).to redirect_to(new_account_session_path)
      end
    end
    context "when account is signed in as freelancer" do
      before do
        sign_in freelancer_account
        delete :destroy ,params: {id:project.id}
      end
      it "should redirect to projects path" do
        expect(response).to redirect_to(projects_path)
      end
    end

    context "when account is signed in as client" do
      before do
        sign_in client_account
        delete :destroy ,params: {id:project.id}
      end
      it "should redirect to projects path" do
        expect(response).to redirect_to(my_projects_path)
      end
    end

    context "when account is signed in as other client" do
      before do
        sign_in client_account1
        delete :destroy  ,params: {id:project.id}
      end
      it "should redirect to projects path" do
        expect(response).to redirect_to(root_path)
      end
    end

  end

  describe "get /projects#client" do
    context "when account is not signed in" do
      before do
         get:client
      end
      it "should redirect to sign in path" do
        expect(response).to redirect_to(new_account_session_path)
      end
    end
    context "when account is signed in as freelancer" do
      before do
        sign_in freelancer_account
        get :client
      end
      it "should redirect to projects path" do
        expect(response).to redirect_to(projects_path)
      end
    end

    context "when account is signed in as client" do
      before do
        sign_in client_account
        get :client
      end
      it "should redirect to projects path" do
        expect(response).to render_template(:client)
      end
    end

  end

  describe "patch /projects#set_available" do
    context "when account is not signed in" do
      before do
          patch :set_available ,params:{id:project.id}
      end
      it "should redirect to sign in path" do
        expect(response).to redirect_to(new_account_session_path)
      end
    end
    context "when account is signed in as freelancer" do
      before do
        sign_in freelancer_account
        patch :set_available ,params:{id:project.id}
      end
      it "should redirect to projects path" do
        expect(response).to redirect_to(projects_path)
      end
    end

    context "when account is signed in as client" do
      before do
        sign_in client_account
        patch :set_available ,params:{id:project.id}
      end
      it "should redirect to projects path" do
        expect(response).to redirect_to(project_path(project.id))
      end
    end
  end

end
