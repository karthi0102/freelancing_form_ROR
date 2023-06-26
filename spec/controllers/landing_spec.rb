require 'rails_helper'

RSpec.describe LandingController, type: :controller do
  let(:client) {create(:client)}
  let(:client_account) {create(:account,:for_client,accountable:client)}
  describe "get /landing#index" do
    context "when user is not signed" do
      before do
        get:index
      end
      it "should redirect to sign in" do
        expect(response).to redirect_to(new_account_session_path)
      end
    end
    context "when user is  signed" do
      before do
        sign_in client_account
        get:index
      end
      it "should render" do
        expect(response).to render_template(:index)
      end
    end
  end
end
