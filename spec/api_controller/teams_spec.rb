require 'rails_helper'

RSpec.describe Api::TeamsController, type: :request do
    let!(:client) {create(:client)}
    let!(:client_account) {create(:account,:for_client,accountable:client)}

    let!(:freelancer) {create(:freelancer)}
    let!(:freelancer_account) {create(:account,:for_freelancer,accountable:freelancer)}

    let!(:freelancer1) {create(:freelancer)}
    let!(:freelancer_account1) {create(:account,:for_freelancer,accountable:freelancer1)}

    let(:freelancer_token) {create(:doorkeeper_access_token,resource_owner_id:freelancer_account.id)}
    let(:freelancer_token1) {create(:doorkeeper_access_token,resource_owner_id:freelancer_account1.id)}
    let(:client_token) {create(:doorkeeper_access_token,resource_owner_id:client_account.id)}

    let(:team) {build(:team,admin:freelancer)}

    describe "get/index" do
      context "when there is no  access token" do
        before do
          get "/api/teams"
        end
        it "should have http status 401" do
          expect(response).to have_http_status(401)
        end
      end
      context "when the user is client" do
        before do
          get "/api/teams",params:{access_token:client_token.token}
        end
        it "should have http status 401" do
          expect(response).to have_http_status(401)
        end
      end
      context "when the user is freelancer" do
        before do
          team.save
          get "/api/teams",params:{access_token:freelancer_token.token}
        end
        it "should have http status 200" do
          expect(response).to have_http_status(200)
        end
      end
      context "when the user is freelancer bt no teams" do
        before do
          Team.delete_all
          get "/api/teams",params:{access_token:freelancer_token.token}
        end
        it "should have http status 204" do
          expect(response).to have_http_status(204)
        end
      end
    end

    describe "post/create" do
      context "when there is no  access token" do
        before do
          post "/api/teams" ,params:{team:{name:"new team2",description:"good team good team good"}}
        end
        it "should have http status 401" do
          expect(response).to have_http_status(401)
        end
      end
      context "when the user is client" do
        before do
          post "/api/teams",params:{team:{name:"new team2",description:"good team good team good"},access_token:client_token.token}
        end
        it "should have http status 401" do
          expect(response).to have_http_status(401)
        end
      end
      context "when the user is freelancer" do
        before do
          post "/api/teams",params:{team:{name:"new team2",description:"good team good team good"},access_token:freelancer_token.token}
        end
        it "should have http status 201" do
          expect(response).to have_http_status(201)
        end
      end
      context "when the user is freelancer but invalid params" do
        before do
          post "/api/teams",params:{team:{name:"",description:"good team good team good"},access_token:freelancer_token.token}
        end
        it "should have http status 422" do
          expect(response).to have_http_status(422)
        end
      end
    end

    describe "patch/update" do
      before(:each) do
        team.save
      end
      context "when there is no  access token" do
        before do
          patch "/api/teams/#{team.id}" ,params:{team:{name:"new team5"}}
        end
        it "should have http status 401" do
          expect(response).to have_http_status(401)
        end
      end
      context "when the user is client" do
        before do
          patch "/api/teams/#{team.id}",params:{team:{name:"new team5"},access_token:client_token.token}
        end
        it "should have http status 401" do
          expect(response).to have_http_status(401)
        end
      end
      context "when the user is freelancer" do
        before do
          patch "/api/teams/#{team.id}",params:{team:{name:"new team5"},access_token:freelancer_token.token}
        end
        it "should have http status 200" do
          expect(response).to have_http_status(200)
        end
      end
      context "when the user is other freelancer" do
        before do
          patch "/api/teams/#{team.id}",params:{team:{name:"new team5"},access_token:freelancer_token1.token}
        end
        it "should have http status 200" do
          expect(response).to have_http_status(401)
        end
      end
    end

    describe "delete/destroy" do
      before(:each) do
        team.save
      end
        context "when there is no  access token" do
          before do
            delete "/api/teams/#{team.id}" ,params:{team:{name:"new team5"}}
          end
          it "should have http status 401" do
            expect(response).to have_http_status(401)
          end
        end
        context "when the user is client" do
          before do
            delete "/api/teams/#{team.id}",params:{team:{name:"new team5"},access_token:client_token.token}
          end
          it "should have http status 401" do
            expect(response).to have_http_status(401)
          end
        end
      context "when the user is freelancer" do
        before do
          delete "/api/teams/#{team.id}",params:{team:{name:"new team5"},access_token:freelancer_token.token}
        end
        it "should have http status 200" do
          expect(response).to have_http_status(303)
        end
      end
      context "when the user is other freelancer" do
        before do
          delete "/api/teams/#{team.id}",params:{team:{name:"new team5"},access_token:freelancer_token1.token}
        end
        it "should have http status 200" do
          expect(response).to have_http_status(401)
        end
      end
    end

    describe "patch/join" do
      before(:each) do
        team.save
      end
      context "when there is no  access token" do
        before do
          patch "/api/teams/join/#{team.id}"
        end
        it "should have http status 401" do
          expect(response).to have_http_status(401)
        end
      end
      context "when the user is client" do
        before do
          patch "/api/teams/join/#{team.id}",params:{access_token:client_token.token}
        end
        it "should have http status 401" do
          expect(response).to have_http_status(401)
        end
      end
      context "when the user is freelancer" do
        before do
          patch "/api/teams/join/#{team.id}",params:{access_token:freelancer_token1.token}
        end
        it "should have http status 200" do
          expect(response).to have_http_status(200)
        end
      end
    end

    describe "patch/remove" do
      before(:each) do
        team.save
      end
      context "when there is no  access token" do
        before do
          patch "/api/teams/remove/#{team.id}/#{freelancer1.id}"
        end
        it "should have http status 401" do
          expect(response).to have_http_status(401)
        end
      end
      context "when the user is client" do
        before do
          patch "/api/teams/remove/#{team.id}/#{freelancer1.id}",params:{access_token:client_token.token}
        end
        it "should have http status 401" do
          expect(response).to have_http_status(401)
        end
      end
      context "when the user is freelancer not in team" do

        before do

          patch "/api/teams/remove/#{team.id}/#{freelancer1.id}",params:{access_token:freelancer_token.token}
        end
        it "should have http status 404" do
          expect(response).to have_http_status(404)
        end
      end
      context "when the user is freelancer" do

        before do
          freelancer1.teams<<team
          freelancer1.save
          patch "/api/teams/remove/#{team.id}/#{freelancer1.id}",params:{access_token:freelancer_token.token}
        end
        it "should have http status 303" do
          expect(response).to have_http_status(303)
        end
      end
      context "when the user is other freelancer" do

        before do
          freelancer1.teams<<team
          freelancer1.save
          patch "/api/teams/remove/#{team.id}/#{freelancer1.id}",params:{access_token:freelancer_token1.token}
        end
        it "should have http status 401" do
          expect(response).to have_http_status(401)
        end
      end
    end

end
