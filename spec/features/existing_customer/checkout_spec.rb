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
             phone: '939-555-0113'
             # user: marge_simpson
            )
    end

    it "completes a checkout" do
      visit spree.product_path(industrial_strength_hairspray)

      # product.add_to_cart
      click_button 'Add To Cart'

      # cart.checkout
      click_button 'Checkout'

      expect(current_path).to eq '/checkout'
      expect(page).to have_css('[data-hook=opco-existing-shipping-address]', count: 1)
      expect(page).to have_css('[data-hook=opco-new-shipping-address]', count: 1)

      # address.choose
      within '[data-hook=opco-shipping-address]' do
        # Select an address from address-book
      end

      expect(current_path).to eq '/checkout'

      pending "further implementation"
    end
  end
end
