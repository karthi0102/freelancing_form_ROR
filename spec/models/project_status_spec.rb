require 'rails_helper'

RSpec.describe ProjectStatus, type: :model do
  describe "associations" do
    context "belongs_to" do
      let(:project_status) {build(:project_status)}
      before do
        project_status.save
      end
      it "project is true" do
        expect(project_status.project).to be_an_instance_of(Project)
      end
    end
    context "belongs_to" do
      let(:project_status) {build(:project_status)}
      before do
        project_status.save
      end
      it "payment is true" do
        expect(project_status.payment).to be_an_instance_of(Payment)
      end
    end
  end

  describe "callbacks" do
    context "set_status" do
      let(:project_status) {build(:project_status)}
      before do
        project_status.save
      end
      it "should be equal to pending" do
          expect(project_status.status).to eq("pending")
      end
    end
  end

end

