require 'spec_helper'

describe CreatePayment do

  describe '#call' do
    let(:payment_factory) { double(:payment_factory) }
    let(:payment_method) { double(:payment_method) }

    subject { CreatePayment.new(payment_factory, payment_method).call(amount, source) }

    let(:amount) { double(:amount) }
    let(:new_payment) { double(:new_payment) }
    let(:source) { double(:source) }

    context "with valid payment attributes" do
      before do
        payment_factory.stub(:create).and_return(new_payment)
      end

      it "persists a new payment" do
        expect(payment_factory).to receive(:create).and_yield(new_payment)

        expect(new_payment).to receive(:amount=).with(amount)
        expect(new_payment).to receive(:payment_method=).with(payment_method)
        expect(new_payment).to receive(:source=).with(source)

        subject
      end

      it "returns the new payment" do
        expect(subject).to eq new_payment
      end
    end

    context "with invalid payment attributes" do
      before do
        payment_factory.stub(:create).and_return(nil)
      end

      it "returns false" do
        expect(subject).to be_nil
      end
    end
  end
end
