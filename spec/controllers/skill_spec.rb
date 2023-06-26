require 'rails_helper'

RSpec.describe SkillsController, type: :controller do
    let(:client) {create(:client)}
    let(:client_account) {create(:account,:for_client,accountable:client)}

    let(:freelancer) {create(:freelancer)}
    let(:freelancer_account) {create(:account,:for_freelancer,accountable:freelancer)}
    let(:skill) {create(:skill,freelancer:freelancer)}

    describe "post /skills/create" do
      context "when account not sigend it" do
        before do
           post :create,params:{skill:{name:"c",level:"Beginner"}}
        end
        it "should redirect sign in page" do
          expect(response).to redirect_to(new_account_session_path)
        end
      end
      context "when account is client" do
        before do
           sign_in client_account
           post :create,params:{skill:{name:"c",level:"Beginner"}}
        end
        it "should redirect to root_path" do
          expect(response).to redirect_to(root_path)
        end
      end
      context "when account is freelancer" do
        before do
           sign_in freelancer_account
           post :create,params:{skill:{name:"c",level:"Beginner"}}
        end
        it "should redirect to root_path" do
          expect(response).to redirect_to(freelancer_profile_path(freelancer))
        end
      end
    end

    describe "delete /skills#destory" do
      context "when account not sigend it" do
        before do
           delete :destroy,params:{id:skill.id}
        end
        it "should redirect sign in page" do
          expect(response).to redirect_to(new_account_session_path)
        end
      end
      context "when account is client" do
        before do
           sign_in client_account
           delete :destroy,params:{id:skill.id}
        end
        it "should redirect to root_path" do
          expect(response).to redirect_to(root_path)
        end
      end

      context "when account is freelancer" do
        before do
           sign_in freelancer_account
           delete :destroy,params:{id:skill.id}
        end
        it "should redirect to freelancer_profile" do
          expect(response).to redirect_to(freelancer_profile_path(freelancer))
        end
      end

    end

end
