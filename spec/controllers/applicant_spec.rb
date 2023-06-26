require 'rails_helper'

RSpec.describe ApplicantController, type: :controller do
      let(:client) {create(:client)}
      let(:client_account) {create(:account,:for_client,accountable:client)}

      let(:client1) {create(:client)}
      let(:client_account1) {create(:account,:for_client,accountable:client1)}

      let(:freelancer) {create(:freelancer)}
      let(:freelancer_account) {create(:account,:for_freelancer,accountable:freelancer)}

      let(:project) {create(:project,client:client)}
      let(:team) {create(:team)}
      let(:applicant1) {create(:applicant,project:project,applicable:freelancer)}

      describe "post /applicants#add_freelancer_applicant" do
        context "when user is not signed in" do
          before do
            post :add_freelancer_applicant,params:{id:project.id}
          end
          it "should redirect to signin page" do
            expect(response).to redirect_to(new_account_session_path)
          end
        end
        context "when user is a client" do
          before do
            sign_in client_account
            post :add_freelancer_applicant,params:{id:project.id}
          end
          it "should redirect to rootpath" do
            expect(response).to redirect_to(root_path)
          end
        end
        context "when user is a freelancer" do
          before do
            sign_in freelancer_account
            post :add_freelancer_applicant,params:{id:project.id}
          end
          it "should redirect to rootpath" do
            expect(response).to redirect_to(project_path(project))
          end
        end
      end

      describe "post /applicants#add_team_applicant" do
        context "when user is not signed in" do
          before do
            post :add_team_applicant,params:{project_id:project.id,team_id:team.id}
          end
          it "should redirect to signin page" do
            expect(response).to redirect_to(new_account_session_path)
          end
        end
        context "when user is a client" do
          before do
            sign_in client_account
            post :add_team_applicant,params:{project_id:project.id,team_id:team.id}
          end
          it "should redirect to rootpath" do
            expect(response).to redirect_to(root_path)
          end
        end
        context "when user is a freelancer" do
          before do
            sign_in freelancer_account
            post :add_team_applicant,params:{project_id:project.id,team_id:team.id}
          end
          it "should redirect to rootpath" do
            expect(response).to redirect_to(project_path(project))
          end
        end

      end
        describe "post /applicants#reject" do
          context "when user is not signed in" do
            before do
              post :reject,params:{applicant_id:applicant1.id}
            end
            it "should redirect to signin page" do
              expect(response).to redirect_to(new_account_session_path)
            end
          end

          context "when user is freelancer" do
            before do
              sign_in freelancer_account
              post :reject,params:{applicant_id:applicant1.id}
            end
            it "should redirect to project page" do
              expect(response).to redirect_to(projects_path)
            end
          end

          context "when user is client and owneer" do
            before do
              sign_in client_account
              post :reject,params:{applicant_id:applicant1.id}
            end
            it "should redirect to project page" do
              expect(response).to redirect_to(project_path(project))
            end
          end

          context "when user is client and not its owneer" do
            before do
              sign_in client_account1
              post :reject,params:{applicant_id:applicant1.id}
            end
            it "should redirect to project page" do
              expect(response).to redirect_to(project_path(project))
            end
          end



      end
end
