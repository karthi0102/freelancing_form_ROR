require 'rails_helper'

RSpec.describe Client, type: :model do
  describe "Validation on company field" do
    context "when company is nil" do
      let(:client) {build(:client,company:nil)}
      before do
        client.save
      end
      it "should return false" do
        expect(client.errors).to include(:company)
      end
    end

    context "when company is empty" do
      let(:client) {build(:client,company:"")}
      before do
        client.save
      end
      it "should return false" do
        expect(client.errors).to include(:company)
      end
    end

    context "when company is correct" do
      let(:client) {build(:client)}
      before do
        client.save
      end
      it "should return false" do
        expect(client.errors).to_not include(:company)
      end
    end
  end

  describe "Validation on company field" do
    context "when company_location is nil" do
      let(:client) {build(:client,company_location:nil)}
      before do
        client.save
      end
      it "should return false" do
        expect(client.errors).to include(:company_location)
      end
    end

    context "when company_location is empty" do
      let(:client) {build(:client,company_location:"")}
      before do
        client.save
      end
      it "should return false" do
        expect(client.errors).to include(:company_location)
      end
    end

    context "when company_location is correct" do
      let(:client) {build(:client)}
      before do
        client.save
      end
      it "should return false" do
        expect(client.errors).to_not include(:company_location)
      end
    end
  end

  describe "association" do
    context "has_many" do
      [:projects].each do |each|
        it each.to_s.humanize do
          association = Client.reflect_on_association(each).macro
          expect(association).to be(:has_many)
        end
      end
    end
    context "has_one" do
      [:account].each do |each|
        it each.to_s.humanize do
          association = Client.reflect_on_association(each).macro
          expect(association).to be(:has_one)
        end
      end
    end
  end

end


