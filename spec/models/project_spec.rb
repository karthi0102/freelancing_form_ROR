require 'rails_helper'

RSpec.describe Project, type: :model do


  describe "Validation on Name Field" do

    context "when name is nil" do
      let(:project) {build(:project , name: "Ragu")}
      before do
        project.save
      end

      it "should return false" do
        expect(project.errors).to include(:name)
      end
    end



  end

end
