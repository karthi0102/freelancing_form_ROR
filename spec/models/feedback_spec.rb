require 'rails_helper'

RSpec.describe Feedback, type: :model do
    describe "Validation on comment field" do
        context "where comment is nil" do
          let(:feedback) {build(:feedback,comment:nil)}
          before do
            feedback.save
          end
          it "should return false" do
            expect(feedback.errors).to include(:comment)
          end
        end
        context "where comment is empty" do
            let(:feedback) {build(:feedback,comment:"")}
            before do
              feedback.save
            end
            it "should return false" do
              expect(feedback.errors).to include(:comment)
            end
          end
          context "where comment is less than 10" do
            let(:feedback) {build(:feedback,comment:"good")}
            before do
              feedback.save
            end
            it "should return false" do
              expect(feedback.errors).to include(:comment)
            end
          end
          context "where comment is greater than 300" do
            let(:feedback) {build(:feedback,comment:"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi utLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi utLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi utLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi utLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut")}
            before do
              feedback.save
            end
            it "should return false" do
              expect(feedback.errors).to include(:comment)
            end
          end
          context "where comment is correct" do
            let(:feedback) {build(:feedback)}
            before do
              feedback.save
            end
            it "should return true" do
              expect(feedback.errors).to_not include(:comment)
            end
          end
    end

    describe "rating" do
      context "when rating is nil" do
        let(:feedback) {build(:feedback,rating:nil)}
        before do
           feedback.save
        end
        it "should return false" do
          expect(feedback.errors).to include(:rating)
        end
      end
      context "when rating is string" do
        let(:feedback) {build(:feedback,rating:"10")}
        before do
           feedback.save
        end
        it "should return false" do
          expect(feedback.errors).to include(:rating)
        end
      end
      context "when rating is negative" do
        let(:feedback) {build(:feedback,rating:-10)}
        before do
           feedback.save
        end
        it "should return false" do
          expect(feedback.errors).to include(:rating)
        end
      end
      context "when rating is less than 1" do
        let(:feedback) {build(:feedback,rating:10)}
        before do
           feedback.save
        end
        it "should return false" do
          expect(feedback.errors).to include(:rating)
        end
      end
      context "when rating is greater than 5" do
        let(:feedback) {build(:feedback,rating:6)}
        before do
           feedback.save
        end
        it "should return false" do
          expect(feedback.errors).to include(:rating)
        end
      end
      context "when rating is float" do
        let(:feedback) {build(:feedback,rating:4.0)}
        before do
           feedback.save
        end
        it "should return false" do
          expect(feedback.errors).to include(:rating)
        end
      end
      context "when rating is in range" do
        let(:feedback) {build(:feedback)}
        before do
           feedback.save
        end
        it "should return true" do
          expect(feedback.errors).to_not include(:rating)
        end
      end
    end

    describe "associations" do
        context "belongs_to_created" do
            let(:feedback) {build(:feedback)}
            before do
              feedback.save
            end
            it "should be a instance of account" do
              expect(feedback.created).to be_an_instance_of(Account)
            end
        end
        context "belongs_to_recepient" do
            let(:feedback) {build(:feedback)}
            before do
              feedback.save
            end
            it "should be a instance of account" do
              expect(feedback.recipient).to be_an_instance_of(Account)
            end
        end
    end
end
