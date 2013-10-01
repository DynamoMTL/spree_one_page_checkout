require 'spec_helper'

module Forms
  describe CreditCardForm do
    describe "validation" do
      let(:credit_card) { Spree::CreditCard.new }
      let(:valid_attributes) { attributes_for(:credit_card).stringify_keys! }

      subject { Forms::CreditCardForm.new(credit_card) }

      shared_examples_for 'an invalid CreditCardForm' do |invalidating_context|
        it "is invalid" do
          valid_attributes.merge(invalidating_context).tap do |attributes|
            expect(subject.validate(attributes)).to be_false
          end
        end
      end

      it "is valid with valid attributes" do
        expect(subject.validate(valid_attributes)).to be_true
      end

      context "without :number present" do
        it_should_behave_like 'an invalid CreditCardForm', 'number' => ''
      end
    end
  end
end
