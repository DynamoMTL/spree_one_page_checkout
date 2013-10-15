require 'spec_helper'

# In order to reduce confusion and thereby grease the wheels of commerce
# As a customer
# Homer Simpson submits invalid or incomplete information and receives instant feedback

describe "A customer", type: :feature, js: true do
  before(:all) { configure_store }

  before do
    sign_up!
  end

  let(:beef_slab) { create(:product) }
  let!(:shipping_method) { create(:shipping_method) }

  context "when submitting invalid address details" do
    it "displays inline form-validation errors" do
      visit spree.product_path(beef_slab)

      # product.add_to_cart
      click_button 'Add To Cart'

      # cart.checkout
      click_button 'Checkout'

      # address.supply
      within '[data-hook=opco-shipping-address]' do
        within '[data-hook=opco-new-address]' do
          click_on 'Add Address'

          fill_in 'First Name', with: 'Guy'
          fill_in 'Last Name', with: 'Incognito'
          fill_in 'Address', with: '1234 Fake St.'
          fill_in 'City', with: 'New York City'
          select 'New York', from: 'State'
          fill_in 'Zip Code', with: '10001'
          fill_in 'Telephone', with: '555-555-1234'

          # Use the default country
          # select 'United States', from: 'Country'

          # Submit empty last name and zip-code
          fill_in 'Last Name', with: ''
          fill_in 'Zip Code', with: ''

          click_button 'Save'
        end
      end

      within '[data-hook=opco-shipping-address]' do
        expect(page).to have_content "can't be blank", count: 2
      end
    end
  end
end
