require 'spec_helper'

# In order to reduce confusion and thereby grease the wheels of commerce
# As a new customer
# Homer Simpson submits receives feedback from Stripe about payment-gateway errors

describe "A new customer", type: :feature, js: true do
  before(:each) { configure_store_with_stripe }
  after(:each) { wait_for_ajax }

  before do
    sign_up!

    visit spree.product_path(beef_slab)

    # product.add_to_cart
    click_button 'Add To Cart'

    # cart.checkout
    click_button 'Checkout'
  end

  let(:beef_slab) { create(:product) }
  let!(:shipping_method) { create(:shipping_method) }

  context "when adding a new credit card" do
    context "when the card is declined" do
      before do
        # credit_card.create
        within '[data-hook=opco-payment-method]' do
          within '[data-hook=opco-new-credit-card]' do
            click_on 'Add Credit Card'

            fill_in 'Card Number', with: '4000000000000002'
            select '1', from: 'Expiration Month'
            select '2015', from: 'Expiration Year'
            fill_in 'Verification Value', with: '123'

            click_button 'Save'
          end
        end
      end

      it "displays the corresponding gateway error message and doesn't persist the card" do
        VCR.use_cassette 'stripe-new-card-declined' do
          within '[data-hook=opco-payment-method]' do
            expect(page).to have_content /Your card was declined/i
            expect(page).to_not have_css('[data-hook=opco-existing-credit-card]')
          end
        end
      end
    end

    context "when the card number is incorrect" do
      before do
        # credit_card.create
        within '[data-hook=opco-payment-method]' do
          within '[data-hook=opco-new-credit-card]' do
            click_on 'Add Credit Card'

            fill_in 'Card Number', with: '4242424242424241'
            select '1', from: 'Expiration Month'
            select '2015', from: 'Expiration Year'
            fill_in 'Verification Value', with: '123'

            click_button 'Save'
          end
        end
      end

      it "displays the corresponding gateway error message and doesn't persist the card" do
        VCR.use_cassette 'stripe-new-card-bad-number' do
          within '[data-hook=opco-payment-method]' do
            expect(page).to have_content /Your card number is incorrect/i
            expect(page).to_not have_css('[data-hook=opco-existing-credit-card]')
          end
        end
      end
    end

    context "when the card is expired" do
      before do
        # credit_card.create
        within '[data-hook=opco-payment-method]' do
          within '[data-hook=opco-new-credit-card]' do
            click_on 'Add Credit Card'

            fill_in 'Card Number', with: '4000000000000069'
            select '1', from: 'Expiration Month'
            select '2015', from: 'Expiration Year'
            fill_in 'Verification Value', with: '123'

            click_button 'Save'
          end
        end
      end

      it "displays the corresponding gateway error message and doesn't persist the card" do
        VCR.use_cassette 'stripe-new-card-expired-card' do
          within '[data-hook=opco-payment-method]' do
            expect(page).to have_content /Your card's expiration date is incorrect/i
            expect(page).to_not have_css('[data-hook=opco-existing-credit-card]')
          end
        end
      end
    end
  end

  context "when reusing an existing credit card" do
    pending "Not sure how to test these"

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
