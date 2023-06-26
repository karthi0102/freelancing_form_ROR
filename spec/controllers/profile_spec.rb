require 'rails_helper'

RSpec.describe ProfileController, type: :controller do
  let(:freelancer) {create(:freelancer)}
  let(:client) {create(:client)}

  let(:freelancer_account) {create(:account,:for_freelancer,accountable:freelancer)}

  describe "get /profile#freelancer" do
    context "when user is not signed in" do
      before do
        get:freelancer,params:{id:freelancer}
      end
      it "should redirect to signin page" do
        expect(response).to redirect_to(new_account_session_path)
      end
    end
    context "when a user hits freelancer profile" do
      before do
        sign_in freelancer_account
        get:freelancer,params:{id:freelancer}
      end
      it "should render template freelancer" do
        expect(response).to render_template(:freelancer)
      end
    end
  end
  describe "get /profile#client" do
    context "when user is not signed in" do
      before do
        get:client,params:{id:client}
      end
      it "should redirect to signin page" do
        expect(response).to redirect_to(new_account_session_path)
      end
    end
    context "when a user hits freelancer profile" do
      before do
        sign_in freelancer_account
        get:client,params:{id:client}
      end
      it "should render template freelancer" do
        expect(response).to render_template(:client)
      end
    end
  end
end
