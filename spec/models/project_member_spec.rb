require 'rails_helper'

RSpec.describe ProjectMember, type: :model do
  describe "association" do
    context "belongs_to project" do
      let(:project_member) {build(:project_member)}
      before do
        project_member.save
      end
      it "should be an instance of project" do
        expect(project_member.project).to be_an_instance_of(Project)
      end
    end
    context "belongs_to " do
      let(:project_member) {build(:project_member, :for_freelancer)}
      before do
        project_member.save
      end
      it "should be an instance of freelancer" do
        expect(project_member.memberable).to be_an_instance_of(Freelancer)
      end
    end
    context "belongs_to " do
      let(:project_member) {build(:project_member, :for_team)}
      before do
        project_member.save
      end
      it "should be an instance of team" do
        expect(project_member.memberable).to be_an_instance_of(Team)
      end
    end

    context "belongs_to " do
      let(:project_member) {build(:project_member, :for_team)}
      before do
        project_member.save
      end
      it "should not be an instance of team" do
        expect(project_member.memberable).to_not be_an_instance_of(Freelancer)
      end
    end
  end

  describe "callbacks" do
    context "status" do
      let(:project_member) {build(:project_member)}
      before do
        project_member.save
      end
      it "should be on-process" do
        expect(project_member.status).to eq("on-process")
      end
    end
    context "feedback" do
      let(:project_member) {build(:project_member)}
      before do
        project_member.save
      end
      it "should be return true" do
        expect(project_member.feedback).to eq(false)
      end
    end
  end
end
