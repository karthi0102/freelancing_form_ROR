require 'rails_helper'

RSpec.describe Project, type: :model do


  describe "Validation on Name Field" do

    before(:each) do
      project.validate
    end

    context "when name is nil" do
      let(:project) {build(:project , name: nil)}
      before do
        project.save
      end

      it "should return false" do
        expect(project.errors).to include(:name)
      end
    end

    context "when name is empty" do
      let(:project) {build(:project , name: "")}
      before do
        project.save
      end

      it "should return false" do
        expect(project.errors).to include(:name)
      end
    end

    context "when name length is less than 5" do
      let(:project) {build(:project , name: "kar")}
      before do
        project.save
      end

      it "should return false" do
        expect(project.errors).to include(:name)
      end
    end

    context "when name length is greater than 5" do
      let(:project) {build(:project , name: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut ")}
      before do
        project.save
      end

      it "should return false" do
        expect(project.errors).to include(:name)
      end
    end

    context "when name length is between than 5 and 30" do
      let(:project) {build(:project)}
      before do
        project.save
      end

      it "should return true" do
        expect(project.errors).to_not include(:name)
      end
    end

  end

  describe "Validation on Description field" do

    before(:each) do
      project.validate
    end

    context "when description is nil" do
      let(:project) {build(:project ,description:nil)}
      before do
        project.save
      end
      it "should return false" do
        expect(project.errors).to include(:description)
      end
    end

    context "when description is empty" do
      let(:project) {build(:project ,description:"")}
      before do
        project.save
      end
      it "should return false" do
        expect(project.errors).to include(:description)
      end
    end


    context "when description is less than 20" do
      let(:project) {build(:project ,description:"hello")}
      before do
        project.save
      end
      it "should return false" do
        expect(project.errors).to include(:description)
      end
    end

    context "when description is between 20 and 500" do
      let(:project) {build(:project)}
      before do
        project.save
      end
      it "should return true" do
        expect(project.errors).to_not include(:description)
      end
    end

    context "when description length is  greater than 500" do
      let(:project) {build(:project ,description:"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi utLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi utLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi utLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi utLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut")}
      before do
        project.save
      end
      it "should return false" do
        expect(project.errors).to include(:description)
      end
    end

  end

  describe "Validation on amount field" do
    before(:each) do
      project.validate
    end

    context "when amount is string" do
      let(:project) {build(:project,amount:"abc")}
      before do
        project.save
      end
      it "should return false" do
        expect(project.errors).to include(:amount)
      end
    end

    context "when amount is nil" do
      let(:project) {build(:project,amount:nil)}
      before do
        project.save
      end
      it "should return false" do
        expect(project.errors).to include(:amount)
      end
    end

    context "when amount is alphanumeric" do
      let(:project) {build(:project,amount:"120abc")}
      before do
        project.save
      end
      it "should return false" do
        expect(project.errors).to include(:amount)
      end
    end

    context "when amount is number" do
      let(:project) {build(:project)}
      before do
        project.save
      end
      it "should return true" do
        expect(project.errors).to_not include(:amount)
      end
    end

    context "when amount is string but only number" do
      let(:project) {build(:project,amount:"10000")}
      before do
        project.save
      end
      it "should return true" do
        expect(project.errors).to_not include(:amount)
      end
    end

    context "when amount is empty string" do
      let(:project) {build(:project,amount:"")}
      before do
        project.save
      end
      it "should return false" do
        expect(project.errors).to include(:amount)
      end
    end

    context "when amount is negative" do
      let(:project) {build(:project,amount:-10)}
      before do
        project.save
      end
      it "should return false" do
        expect(project.errors).to include(:amount)
      end
    end

    context "when amount is less than 5000" do
      let(:project) {build(:project,amount:100)}
      before do
        project.save
      end
      it "should return false" do
        expect(project.errors).to include(:amount)
      end
    end

    context "when amount is greater than or equal to  5000" do
      let(:project) {build(:project)}
      before do
        project.save
      end
      it "should return false" do
        expect(project.errors).to_not include(:amount)
      end
    end

    context "when amount is float" do
      let(:project) {build(:project,amount:5000.0)}
      before do
        project.save
      end
      it "should return false" do
        expect(project.errors).to include(:amount)
      end
    end

  end


  describe "association" do

      context "belongs_to" do
        let(:client) {create(:client)}
        let(:project) {build(:project, client: client)}

        before do
          project.save
        end

        it "should have client" do
          expect(project.client).to be_an_instance_of(Client)
        end
      end

      context "belongs_to" do
        let(:project) {build(:project, client: nil)}

        before do
          project.save
        end

        it "should have not client" do
          expect(project.client).to_not be_an_instance_of(Client)
        end
      end

      context "has_many" do
        [:project_members,:applicants].each do |each|
          it each.to_s.humanize do
            association = Project.reflect_on_association(each).macro
            expect(association).to be(:has_many)
          end
        end
      end
      context "has_one" do
        [:project_status].each do |each|
          it each.to_s.humanize do
            association = Project.reflect_on_association(each).macro
            expect(association).to be(:has_one)
          end
        end
      end

  end

  describe "callbacks" do
    context "set_available_to_true" do
      let(:project) {build(:project)}
      before do
        project.save
      end
      it "should be true" do
        expect(project.reload.available).to eq(true)
      end
    end
  end


end
