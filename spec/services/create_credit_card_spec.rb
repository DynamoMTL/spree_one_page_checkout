require 'spec_helper'

describe CreateCreditCard do
  describe '#call' do
    let(:credit_card_factory) { double(:credit_card_factory) }
    let(:credit_card_form) { double(:credit_card_form) }

    subject { CreateCreditCard.new(credit_card_factory, credit_card_form) }

    let(:credit_card_attrs) { double(:credit_card_attrs) }
    let(:credit_card_form_nested_data) { double(:credit_card_form_nested_data) }

    it "validates the credit-card submission" do
      expect(credit_card_form).to receive(:validate).with(credit_card_attrs)

      subject.call(credit_card_attrs)
    end

    context "with valid credit-card attributes" do
      before do
        credit_card_form.stub(:validate).and_return(true)
        credit_card_form.stub(:save).and_yield(double, credit_card_form_nested_data)
      end

      it "persists a new credit-card" do
        expect(credit_card_factory).to receive(:create!).with(credit_card_form_nested_data)

        subject.call(credit_card_attrs)
      end
    end

    context "with invalid credit-card attributes" do
      before do
        credit_card_form.stub(:validate).and_return(false)
      end

      it "returns false" do
        expect(subject.call(credit_card_attrs)).to be_nil
      end
    end
  end
end
