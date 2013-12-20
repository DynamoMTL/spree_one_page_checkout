require 'spec_helper'

module Forms

  describe AddressForm do

    describe "attribute mapping", pending: "a working aliasing feature in Reform" do
      let(:address) { build(:address) }

      subject { Forms::AddressForm.new(address) }

      it "maps :first_name to :firstname" do
        expect(subject.first_name).to eq address.firstname
      end

      it "maps :last_name to :lastname" do
        expect(subject.last_name).to eq address.lastname
      end

      it "maps :address1 to :street_address" do
        expect(subject.street_address).to eq address.address1
      end

      it "maps :zipcode to :zip_code" do
        expect(subject.zip_code).to eq address.zipcode
      end

      it "maps :phone to :telephone" do
        expect(subject.telephone).to eq address.phone
      end
    end

    describe "validation" do
      let(:address) { Spree::Address.new }

      let(:valid_attributes) {{
        firstname: Faker::Name.first_name,
        lastname: Faker::Name.last_name,
        company: Faker::Company.name,
        address1: Faker::Address.street_address,
        address2: Faker::Address.secondary_address,
        city: Faker::Address.city,
        state_name: Faker::AddressUS.state,
        zipcode: Faker::AddressUS.zip_code,
        country_id: '1',
        phone: Faker::PhoneNumber.short_phone_number,
        alternative_phone: Faker::PhoneNumber.short_phone_number
      }.stringify_keys}

      subject { Forms::AddressForm.new(address) }

      shared_examples_for 'an invalid AddressForm' do |invalidating_context|
        it "is invalid" do
          valid_attributes.merge(invalidating_context).tap do |attributes|
            expect(subject.validate(attributes)).to be_false
          end
        end
      end

      it "is valid with valid attributes" do
        expect(subject.validate(valid_attributes)).to be_true
      end

      context "without :firstname present" do
        it_should_behave_like 'an invalid AddressForm', 'firstname' => ''
      end

      context "without :lastname present" do
        it_should_behave_like 'an invalid AddressForm', 'lastname' => ''
      end

      context "without :address1 present" do
        it_should_behave_like 'an invalid AddressForm', 'address1' => ''
      end

      context "without :city present" do
        it_should_behave_like 'an invalid AddressForm', 'city' => ''
      end

      context "without :state_name present" do
        context "and Spree is configured to require state information" do
          it_should_behave_like 'an invalid AddressForm', 'state_name' => ''
        end
      end

      context "without :country_id present" do
        it_should_behave_like 'an invalid AddressForm', 'country_id' => ''
      end

      context "without :phone present" do
        it_should_behave_like 'an invalid AddressForm', 'phone' => ''
      end
    end
  end
end
