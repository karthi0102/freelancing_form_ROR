require 'rails_helper'

RSpec.describe Api::ProjectsController, type: :request do
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
  let(:team){create(:team)}

  
  describe "get index" do
    context "when there is not access token" do
      before do
        get "/api/projects/"
      end
      it "should have http status 401" do
        expect(response).to have_http_status(401)
      end
    end
    context "when the user is freelancer" do
      before do
        get "/api/projects/",params:{access_token:freelancer_token.token}
      end
      it "should have http status 200" do
        expect(response).to have_http_status(200)
      end
    end
    context "when the user is freelancer and no projects" do

      before do
        Project.destroy_all
        get "/api/projects/",params:{access_token:freelancer_token.token}

      end
      it "should have http status 204" do
        expect(response).to have_http_status(204)
      end
    end
    context "when the user is client" do
      before do
        get "/api/projects/",params:{access_token:client_token.token}
      end
      it "should have http status 401" do
        expect(response).to have_http_status(401)
      end
    end

  end

  describe "get/show" do
    context "when there is not access token" do
      before do
        get "/api/projects/#{project.id}"
      end
      it "should have http status 401" do
        expect(response).to have_http_status(401)
      end
    end
    context "when there is access token" do
      before do
        get "/api/projects/#{project.id}" ,params:{access_token:freelancer_token.token}
      end
      it "should have http status 200" do
        expect(response).to have_http_status(200)
      end
    end
    context "when there is access token but invalid project" do
      before do
        get "/api/projects/a1" ,params:{access_token:freelancer_token.token}
      end
      it "should have http status 404" do
        expect(response).to have_http_status(404)
      end
    end
  end

  describe "post#create" do
    context "when there is not access token" do
      before do
        post "/api/projects" ,params:{project:{name:"new project",description:project.description,amount:7000}}
      end
      it "should have http status 401" do
        expect(response).to have_http_status(401)
      end
    end
    context "when the user is freelancer" do
      before do
        post "/api/projects" ,params:{access_token:freelancer_token.token,project:{name:"new project",description:project.description,amount:7000}}
      end
      it "should have http status 401" do
        expect(response).to have_http_status(401)
      end
    end
    context "when the user is client" do
      before do
        post "/api/projects" ,params:{access_token:client_token.token,project:{name:"new project",description:project.description,amount:7000}}
      end
      it "should have http status 201" do
        expect(response).to have_http_status(201)
      end
    end
    context "when the user is client and invalid params" do
      before do
        post "/api/projects" ,params:{access_token:client_token.token,project:{name:"new project",description:project.description,amount:1000}}
      end
      it "should have http status 422" do
        expect(response).to have_http_status(422)
      end
    end

  end

  describe "patch#update" do
    context "when there is not access token" do
      before do
        patch "/api/projects/#{project.id}" ,params:{project:{name:"new project"}}
      end
      it "should have http status 401" do
        expect(response).to have_http_status(401)
      end
    end
    context "when the user is freelancer" do
      before do
        patch "/api/projects/#{project.id}" ,params:{access_token:freelancer_token.token,project:{name:"new project"}}
      end
      it "should have http status 401" do
        expect(response).to have_http_status(401)
      end
    end
    context "when the user is client" do
      before do
        patch "/api/projects/#{project.id}" ,params:{access_token:client_token.token,project:{name:"new project"}}
      end
      it "should have http status 200" do
        expect(response).to have_http_status(200)
      end
    end
    context "when the user is client and invalid params" do
      before do
        patch "/api/projects/#{project.id}" ,params:{access_token:client_token.token,project:{name:"n"}}
      end
      it "should have http status 200" do
        expect(response).to have_http_status(422)
      end
    end
    context "when the user is other client" do
      before do
        patch "/api/projects/#{project.id}" ,params:{access_token:client_token1.token,project:{name:"new project"}}
      end
      it "should have http status 401" do
        expect(response).to have_http_status(401)
      end
    end
  end

  describe "delete#destory" do
    context "when there is not access token" do
      before do
        delete "/api/projects/#{project.id}"
      end
      it "should have http status 401" do
        expect(response).to have_http_status(401)
      end
    end
    context "when the user is freelancer" do
      before do
        delete "/api/projects/#{project.id}" ,params:{access_token:freelancer_token.token}
      end
      it "should have http status 401" do
        expect(response).to have_http_status(401)
      end
    end
    context "when the user is client" do
      before do
        delete "/api/projects/#{project.id}" ,params:{access_token:client_token.token}
      end
      it "should have http status 200" do
        expect(response).to have_http_status(303)
      end
    end
    context "when the user is client and project id is invalid" do
      before do
        delete "/api/projects/1bc" ,params:{access_token:client_token.token}
      end
      it "should have http status 200" do
        expect(response).to have_http_status(404)
      end
    end
    context "when the user is other client" do
      before do
        delete "/api/projects/#{project.id}" ,params:{access_token:client_token1.token}
      end
      it "should have http status 401" do
        expect(response).to have_http_status(401)
      end
    end
  end

  describe "get#available_projects" do
    context "when there is not access token" do
      before do
        get "/api/projects/available_projects"
      end
      it "should have http status 401" do
        expect(response).to have_http_status(401)
      end
    end
    context "when the user is client" do
      before do
        get "/api/projects/available" ,params:{access_token:client_token.token}
      end
      it "should have http status 401" do
        expect(response).to have_http_status(401)
      end
    end
    context "when the user is freelancer" do
      before do
        get "/api/projects/available" ,params:{access_token:freelancer_token.token}
      end
      it "should have http status 200" do
        expect(response).to have_http_status(200)
      end
    end
    context "when the user is freelancer and project is empty" do
      before do
        Project.destroy_all
        get "/api/projects/available" ,params:{access_token:freelancer_token.token}
      end
      it "should have http status 204" do
        expect(response).to have_http_status(204)
      end
    end
  end

  describe "get/client" do

    context "when there is not access token" do
      before do
        get "/api/projects/client"
      end
      it "should have http status 401" do
        expect(response).to have_http_status(401)
      end
    end
    context "when the user is freelancer" do
      before do
        get "/api/projects/client" ,params:{access_token:freelancer_token.token}
      end
      it "should have http status 401" do
        expect(response).to have_http_status(401)
      end
    end
    context "when the user is client" do
      before do
        get "/api/projects/client" ,params:{access_token:client_token.token}
      end
      it "should have http status 200" do
        expect(response).to have_http_status(200)
      end
    end


  end


  describe "get/freelancer" do

    context "when there is not access token" do
      before do
        get "/api/projects/freelancer"
      end
      it "should have http status 401" do
        expect(response).to have_http_status(401)
      end
    end
    context "when the user is freelancer" do
      before do
        get "/api/projects/freelancer" ,params:{access_token:freelancer_token.token}
      end
      it "should have http status 200" do
        expect(response).to have_http_status(200)
      end
    end
    context "when the user is client" do
      before do
        get "/api/projects/freelancer" ,params:{access_token:client_token.token}
      end
      it "should have http status 401" do
        expect(response).to have_http_status(401)
      end
    end


  end

  describe "get/team" do

    context "when there is not access token" do
      before do
        get "/api/projects/team/#{team.id}"
      end
      it "should have http status 401" do
        expect(response).to have_http_status(401)
      end
    end
    context "when the user has access token" do
      before do
        get "/api/projects/team/#{team.id}" ,params:{access_token:freelancer_token.token}
      end
      it "should have http status 200" do
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "patch/set_available" do
    context "when there is not access token" do
      before do
        patch "/api/project/set_available/#{project.id}"
      end
      it "should have http status 401" do
        expect(response).to have_http_status(401)
      end
    end

    context "when the user is freelancer" do
      before do
        patch "/api/project/set_available/#{project.id}" ,params:{access_token:freelancer_token.token,project:{name:"new project"}}
      end
      it "should have http status 401" do
        expect(response).to have_http_status(401)
      end
    end
    context "when the user is client" do
      before do
        patch "/api/project/set_available/#{project.id}" ,params:{access_token:client_token.token,project:{name:"new project"}}
      end
      it "should have http status 200" do
        expect(response).to have_http_status(200)
      end
    end

    context "when the user is other client" do
      before do
        patch "/api/project/set_available/#{project.id}" ,params:{access_token:client_token1.token,project:{name:"new project"}}
      end
      it "should have http status 401" do
        expect(response).to have_http_status(401)
      end
    end
  end





end
