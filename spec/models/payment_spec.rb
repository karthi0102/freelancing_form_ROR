require 'rails_helper'

RSpec.describe Payment, type: :model do
   describe "association" do
      context "has_one" do
          [:project_status].each do |each|
            it each.to_s.humanize do
              association = Payment.reflect_on_association(each).macro
              expect(association).to be(:has_one)
            end
        end
      end
   end
   describe "callbacks" do
      context "set_status" do
        let(:payment) {build(:payment)}
        before do
          payment.save
        end
        it "be equal to pending" do
          expect(payment.status).to eq("pending")
        end
      end
   end
end
