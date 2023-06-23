require 'rails_helper'

RSpec.describe Skill, type: :model do

  describe "Validation on name field" do

    context "when name is nil" do
      let(:skill) {build(:skill,name:nil)}
      before do
        skill.save
      end
      it "should return false" do
        expect(skill.errors).to include(:name)
      end
    end


    context "when name is empty" do
      let(:skill) {build(:skill,name:"")}
      before do
        skill.save
      end
      it "should return false" do
        expect(skill.errors).to include(:name)
      end
    end

    context "when name is correct" do
      let(:skill) {build(:skill)}
      before do
        skill.save
      end
      it "should return true" do
        expect(skill.errors).to_not include(:name)
      end
    end

  end

  describe "Validation on level field" do
    context "when level is nil" do
      let(:skill) {build(:skill,level:nil)}
      before do
        skill.save
      end
      it "should return false" do
        expect(skill.errors).to include(:level)
      end
    end

    context "when level is empty" do
      let(:skill) {build(:skill,level:"")}
      before do
        skill.save
      end
      it "should return false" do
        expect(skill.errors).to include(:level)
      end
    end

    context "when level is correct" do
      let(:skill) {build(:skill)}
      before do
        skill.save
      end
      it "should return true" do
        expect(skill.errors).to_not include(:level)
      end
    end

  end

  describe "associations" do

    context "belongs_to" do
      let(:freelancer) {create(:freelancer)}
      let(:skill) {build(:skill,freelancer:freelancer)}

      before do
        skill.save
      end
      it "should be instance of freelancer" do
        expect(skill.freelancer).to be_an_instance_of(Freelancer)
      end
    end

    context "belongs_to" do
    
      let(:skill) {build(:skill,freelancer:nil)}

      before do
        skill.save
      end
      it "should not_be instance of freelancer" do
        expect(skill.freelancer).to_not be_an_instance_of(Freelancer)
      end
    end

  end

end
