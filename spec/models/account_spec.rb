require 'rails_helper'

RSpec.describe Account, type: :model do

   describe "Validation on Name Field" do
     before(:each) do
       account.validate
     end

     context "when name field is nil" do
        let(:account) {build(:account,name:nil)}
         before do
           account.save
         end
         it "should return false" do
           expect(account.errors).to include(:name)
         end
     end

     context "when name field is empty" do
      let(:account) {build(:account,name:"")}
       before do
         account.save
       end
       it "should return false" do
         expect(account.errors).to include(:name)
       end
      end

      context "when name field is less than 5" do
        let(:account) {build(:account,name:"kar")}
         before do
           account.save
         end
         it "should return false" do
           expect(account.errors).to include(:name)
         end
        end

        context "when name field is greater than 20" do
          let(:account) {build(:account,name:"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took ")}
           before do
             account.save
           end
           it "should return false" do
             expect(account.errors).to include(:name)
           end
        end

        context "when name field is between 5 and  20" do
          let(:account) {build(:account,name:"Karthikeyan")}
           before do
             account.save
           end
           it "should return true" do
             expect(account.errors).to_not include(:name)
           end
        end
   end

   describe "Validation on email field" do

    before(:each) do
      account.validate
    end
    context "when email is nill" do
      let(:account) {build(:account,email:nil)}
      before do
        account.save
      end
      it "should return false" do
        expect(account.errors).to include(:email)
      end
    end

    context "when email is in wrong format" do
      let(:account) {build(:account,email:"karthi")}
      before do
        account.save
      end
      it "should return false" do
        expect(account.errors).to include(:email)
      end
    end

    context "when email is in empty" do
      let(:account) {build(:account,email:"")}
      before do
        account.save
      end
      it "should return false" do
        expect(account.errors).to include(:email)
      end
    end

    context "when email is in correct" do
      let(:account) {build(:account)}
      before do
        account.save
      end
      it "should return true" do
        expect(account.errors).to_not include(:email)
      end
    end
   end

   describe "Validation on Phone field" do

    context "when phone is nil" do
      let(:account){build(:account,phone:nil)}
      before do
        account.save
      end
      it "should return false" do
        expect(account.errors).to include(:phone)
      end
    end

    context "when phone is empty" do
      let(:account){build(:account,phone:"")}
      before do
        account.save
      end
      it "should return false" do
        expect(account.errors).to include(:phone)
      end
    end

    context "when phone length is less than 10 " do
      let(:account){build(:account,phone:"123")}
      before do
        account.save
      end
      it "should return false" do
        expect(account.errors).to include(:phone)
      end
    end

    context "when phone length is higher than 10 " do
      let(:account){build(:account,phone:"123456789012")}
      before do
        account.save
      end
      it "should return false" do
        expect(account.errors).to include(:phone)
      end
    end
    context "when phone contains other characters" do
      let(:account){build(:account,phone:"9856p$6641")}
      before do
        account.save
      end
      it "should return false" do
        expect(account.errors).to include(:phone)
      end
    end

    context "when contact only contains zero" do
      let(:account){build(:account,phone:"0000000000")}
      before do
        account.save
      end
      it "should return false" do
        expect(account.errors).to include(:phone)
      end
    end

    context "when phone length is  10 " do
      let(:account){build(:account)}
      before do
        account.save
      end
      it "should return true" do
        expect(account.errors).to_not include(:phone)
      end
    end

   end


   describe "Validation on gender field" do

    context "when gender is nil" do
      let(:account) {build(:account,gender:nil)}
      before do
        account.save
      end
      it "should return false" do
        expect(account.errors).to include(:gender)
      end
    end

    context "when gender is empty" do
      let(:account) {build(:account,gender:" ")}
      before do
        account.save
      end
      it "should return false" do
        expect(account.errors).to include(:gender)
      end
    end

    context "when gender is not in the given value" do
      let(:account) {build(:account,gender:"human")}
      before do
        account.save
      end
      it "should return false" do
        expect(account.errors).to include(:gender)
      end
    end

    context "when gender is correct" do
      let(:account) {build(:account)}
      before do
        account.save
      end
      it "should return true" do
        expect(account.errors).to_not include(:gender)
      end
    end

    end

    describe "Validation on Password field" do

      context "when password is nil" do
        let(:account) {build(:account,password:nil,password_confirmation:nil)}

        before do
          account.save
        end

        it "should return false" do
          expect(account.errors).to include(:password)
        end
      end

      context "when password is empty" do
        let(:account) {build(:account,password:"",password_confirmation:"")}

        before do
          account.save
        end

        it "should return false" do
          expect(account.errors).to include(:password)
        end
      end

      context "when password does not matches password confirmation" do
        let(:account) {build(:account,password:"123456",password_confirmation:"1234567")}

        before do
          account.save
        end

        it "should return false" do
          expect(account.errors).to include(:password_confirmation)
        end
      end
      context "when password does  matches password confirmation" do
        let(:account) {build(:account,password:"123456",password_confirmation:"123456")}

        before do
          account.save
        end

        it "should return true" do
          expect(account.errors).to_not include(:password_confirmation)
        end
      end

      context "when password is less than 6 charaters" do
        let(:account) {build(:account,password:"123",password_confirmation:"123")}

        before do
          account.save
        end

        it "should return false" do
          expect(account.errors).to include(:password)
        end
      end

      context "when password is greater than or equal to 6 charaters" do
        let(:account) {build(:account)}

        before do
          account.save
        end

        it "should return true" do
          expect(account.errors).to_not include(:password)
        end
      end

    end


    describe "Validation on Description field" do

      before(:each) do
        account.validate
      end

      context "when description is nil" do
        let(:account) {build(:account ,description:nil)}
        before do
          account.save
        end
        it "should return false" do
          expect(account.errors).to include(:description)
        end
      end

      context "when description is empty" do
        let(:account) {build(:account ,description:"")}
        before do
          account.save
        end
        it "should return false" do
          expect(account.errors).to include(:description)
        end
      end


      context "when description is less than 20" do
        let(:account) {build(:account ,description:"hello")}
        before do
          account.save
        end
        it "should return false" do
          expect(account.errors).to include(:description)
        end
      end

      context "when description is between 20 and 500" do
        let(:account) {build(:account)}
        before do
          account.save
        end
        it "should return true" do
          expect(account.errors).to_not include(:description)
        end
      end

      context "when description length is  greater than 500" do
        let(:account) {build(:account ,description:"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi utLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi utLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi utLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi utLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut")}
        before do
          account.save
        end
        it "should return false" do
          expect(account.errors).to include(:description)
        end
      end
    end

    describe "association" do
      context "belongs_to" do
        let(:account) {create(:account , :for_freelancer)}
        it "should be instance of freelancer" do
          expect(account.accountable).to be_an_instance_of(Freelancer)
        end
      end

      context "belongs_to" do
        let(:account) {create(:account , :for_client)}
        it "should be instance of client" do
          expect(account.accountable).to be_an_instance_of(Client)
        end
      end

      context "belongs_to" do
        let(:account) {create(:account , :for_freelancer)}
        it "should not be an instance of client" do
          expect(account.accountable).to_not be_an_instance_of(Client)
        end
      end

      context "has_many" do
          [:received_feedbacks,:created_feedbacks].each do |each|
            it each.to_s.humanize do
                association = Account.reflect_on_association(each).macro
                expect(association).to be(:has_many)
            end
          end
      end

  end

end
