require 'rails_helper'

RSpec.describe Team, type: :model do

  describe "Validation on  name field" do
    context "when name is nil" do
      let(:team) {build(:team,name:nil)}
      before do
        team.save
      end
      it "should return false" do
        expect(team.errors).to include(:name)
      end
    end
    context "when name is empty" do
      let(:team) {build(:team,name:"")}
      before do
        team.save
      end
      it "should return false" do
        expect(team.errors).to include(:name)
      end
    end
    context "when name is less than 5" do
      let(:team) {build(:team,name:"tea")}
      before do
        team.save
      end
      it "should return false" do
        expect(team.errors).to include(:name)
      end
    end
    context "when name is greater than 20" do
      let(:team) {build(:team,name:"qwertyuioplkjhgfdsazxcvbnm")}
      before do
        team.save
      end
      it "should return false" do
        expect(team.errors).to include(:name)
      end
    end
    context "when name is correct" do
      let(:team) {build(:team)}
      before do
        team.save
      end
      it "should return true" do
        expect(team.errors).to_not include(:name)
      end
    end
  end

  describe "Validation on description field" do
    context "when description is nil" do
        let(:team){build(:team,description:nil)}
        before do
          team.save
        end
        it "should return false" do
          expect(team.errors).to include(:description)
        end
    end
    context "when description is empty" do
      let(:team){build(:team,description:"")}
      before do
        team.save
      end
      it "should return false" do
        expect(team.errors).to include(:description)
      end
  end
  context "when description is less than 20" do
    let(:team){build(:team,description:"hello")}
    before do
      team.save
    end
    it "should return false" do
      expect(team.errors).to include(:description)
    end
  end

  context "when description is greater than 500" do
    let(:team){build(:team,description:"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi utLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi utLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi utLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi utLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut")}
    before do
      team.save
    end
    it "should return false" do
      expect(team.errors).to include(:description)
    end
  end
  end

  describe "association" do
    context "belongs_to" do
      let(:freelancer) {create(:freelancer)}
      let(:team) {build(:team, admin: freelancer)}
        before do
          team.save
        end
        it "should have client" do
          expect(team.admin).to be_an_instance_of(Freelancer)
        end
    end
  end

end
