require 'spec_helper'

# In order to restock the copious amounts of hairspray she requires daily
# As a long-time customer
# Marge Simpson can check out

describe "An existing customer", type: :feature, js: true do
  before(:all) { configure_store }

  before do
    sign_in_as!(marge_simpson)
  end

  let(:industrial_strength_hairspray) { create(:product) }
  let(:marge_simpson) { create(:user) }

  context "with a credit card" do
    before do
      create(:address,
             firstname: 'Marge',
             lastname: 'Simpson',
             address1: '742 Evergreen Terrace',
             city: 'Springfield',
             state_name: 'North Takoma',
             zipcode: '90701',
             phone: '939-555-0113',
             user: marge_simpson
            )

      create(:credit_card,
             number: 4111111111111111,
             month: 12,
             year: 2016,
             verification_value: 123,
             user: marge_simpson
            )
    end

    it "completes a checkout" do
      visit spree.product_path(industrial_strength_hairspray)

      # product.add_to_cart
      click_button 'Add To Cart'

      # cart.checkout
      click_button 'Checkout'

      expect(current_path).to eq '/checkout'

      # FIXME (Temporary) DMA object
      current_order = Spree::User.first.orders.first

      within '[data-hook=opco-shipping-address]' do
        expect(page).to have_css('[data-hook=opco-existing-address]', count: 1, text: /742 Evergreen Terrace/)
        expect(page).to have_css('[data-hook=opco-new-address]', count: 1)
      end

      within '[data-hook=opco-shipping-address]' do
        find('[data-hook=opco-existing-address] a', text: /742 Evergreen Terrace/).click

        expect(page).to have_css('[data-hook=opco-address-book] .selected')
        expect(current_order.reload.ship_address.address1).to match(/742 Evergreen Terrace/)
      end

      within '[data-hook=opco-payment-method]' do
        find('[data-hook=opco-existing-credit-card] a', text: /1111/).click

        sleep 5

        expect(page).to have_css('[data-hook=opco-credit-card-wallet] .selected')

        current_order.reload.tap do |order|
          expect(order.payments).to have(1).item
        end
      end

      pending "further implementation"
    end
  end
end
