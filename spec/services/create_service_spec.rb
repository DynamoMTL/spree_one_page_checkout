require 'spec_helper'

describe CreateAddress do

  describe '#call' do
    let(:address_factory) { double(:address_factory) }
    let(:address_form) { double(:address_form) }

    subject { CreateAddress.new(address_factory, address_form) }

    let(:address_attrs) { double(:address_attrs) }
    let(:address_form_nested_data) { double(:address_form_nested_data) }

    it "validates the address submission" do
      expect(address_form).to receive(:validate).with(address_attrs)

      subject.call(address_attrs)
    end

    context "with valid address attributes" do
      before do
        address_form.stub(:validate).and_return(true)
        address_form.stub(:save).and_yield(double, address_form_nested_data)
      end

      it "persists a new address" do
        expect(address_factory).to receive(:create!).with(address_form_nested_data)

        subject.call(address_attrs)
      end
    end

    context "with invalid address attributes" do
      before do
        address_form.stub(:validate).and_return(false)
      end

      it "returns false" do
        expect(subject.call(address_attrs)).to be_nil
      end
    end
  end
end
