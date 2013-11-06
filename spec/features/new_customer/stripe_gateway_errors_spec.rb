require 'spec_helper'

# In order to reduce confusion and thereby grease the wheels of commerce
# As a new customer
# Homer Simpson submits receives feedback from Stripe about payment-gateway errors

describe "A new customer", type: :feature, js: true do
  before(:all) { configure_store_with_stripe }

  before do
    sign_up!
  end

  let(:beef_slab) { create(:product) }
  let!(:shipping_method) { create(:shipping_method) }

  context "when adding a new credit card" do
    context "when the card is declined" do
      it "displays the corresponding gateway error message"
      it "doesn't persist the credit card"
    end

    context "when the card number is incorrect" do
      it "displays the corresponding gateway error message"
      it "doesn't persist the credit card"
    end

    context "when the card is expired" do
      it "displays the corresponding gateway error message"
      it "doesn't persist the credit card"
    end
  end

  context "when reusing an existing credit card" do
    context "when the card is declined" do
      it "displays the corresponding gateway error message"
      it "retains the credit card"
    end

    context "when the card number is incorrect" do
      it "displays the corresponding gateway error message"
      it "retains the credit card"
    end

    context "when the card is expired" do
      it "displays the corresponding gateway error message"
      it "retains the credit card"
    end
end
end
