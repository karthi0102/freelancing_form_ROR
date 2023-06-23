require 'rails_helper'

RSpec.describe Applicant, type: :model do
  describe "associations" do
    context "belongs_to" do
      let(:applicant){build(:applicant, :for_freelancer)}
      before do
        applicant.save
      end
      it "should belong to freelancer" do
        expect(applicant.applicable).to be_an_instance_of(Freelancer)
      end
    end
    context "belongs_to" do
      let(:applicant){build(:applicant, :for_team)}
      before do
        applicant.save
      end
      it "should belong to team" do
        expect(applicant.applicable).to be_an_instance_of(Team)
      end
    end
    context "belongs_to" do
      let(:applicant){build(:applicant, :for_freelancer)}
      before do
        applicant.save
      end
      it "should not belong to team" do
        expect(applicant.applicable).to_not be_an_instance_of(Team)
      end
    end
  end

  describe "callbacks" do
    context "set_status" do
      let(:applicant) {build(:applicant)}
      before do
        applicant.save
      end
      it "should be applied" do
        expect(applicant.status).to eq("applied")
      end
    end
  end
end


