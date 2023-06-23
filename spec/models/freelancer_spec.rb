require 'rails_helper'

RSpec.describe Freelancer, type: :model do

  describe "Validation on github link" do

    context "when github is nil" do
      let(:freelancer) {build(:freelancer,github:nil)}

      before do
        freelancer.save
      end

      it "should return false" do
        expect(freelancer.errors).to include(:github)
      end

    end

    context "when github is empty" do
      let(:freelancer) {build(:freelancer,github:" ")}

      before do
        freelancer.save
      end

      it "should return false" do
        expect(freelancer.errors).to include(:github)
      end

    end

    context "when github is correct" do
      let(:freelancer) {build(:freelancer)}

      before do
        freelancer.save
      end

      it "should return true" do
        expect(freelancer.errors).to_not include(:github)
      end

    end
  end


  describe "Validation on Experience field" do

    context "when experience is nil" do
      let(:freelancer) {build(:freelancer,experience:nil)}
      before do
        freelancer.save
      end
      it "should return false" do
        expect(freelancer.errors).to include(:experience)
      end
    end

    context "when experience is empty" do
      let(:freelancer) {build(:freelancer,experience:"")}
      before do
        freelancer.save
      end
      it "should return false" do
        expect(freelancer.errors).to include(:experience)
      end
    end
    context "when experience is less than 20" do
      let(:freelancer) {build(:freelancer,experience:"hello")}
      before do
        freelancer.save
      end
      it "should return false" do
        expect(freelancer.errors).to include(:experience)
      end
    end

    context "when experience is greater than 500" do
      let(:freelancer) {build(:freelancer,experience:"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi utLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi utLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi utLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi utLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut")}
      before do
        freelancer.save
      end
      it "should return false" do
        expect(freelancer.errors).to include(:experience)
      end
    end

    context "when experience is between 20 and 500" do
      let(:freelancer) {build(:freelancer)}
      before do
        freelancer.save
      end
      it "should return false" do
        expect(freelancer.errors).to_not include(:experience)
      end
    end

  end

end
