require 'spec_helper'

# In order to pay for the massive slab of Nebraska beef in his cart
# As a brand-new customer
# Homer Simpson can check out

describe "A new customer", type: :feature, js: true do
  before(:all) { configure_store }

  before do
    sign_up!
  end

  let(:beef_slab) { create(:product) }
  let!(:shipping_method) { create(:shipping_method) }

  context "with a credit card" do
    it "completes a checkout" do
      visit spree.product_path(beef_slab)

      # product.add_to_cart
      click_button 'Add To Cart'

      # cart.checkout
      click_button 'Checkout'

      expect(current_path).to eq '/checkout'

      within '[data-hook=opco-shipping-address]' do
        expect(page).to_not have_css('[data-hook=opco-existing-address]')
      end

      # (Temporary) DMA objects
      current_user  = Spree::User.first
      current_order = Spree::User.first.orders.first

      # address.supply
      within '[data-hook=opco-shipping-address]' do
        within '[data-hook=opco-new-address]' do
          click_on 'Add Address'

          fill_in 'First Name', with: 'Guy'
          fill_in 'Last Name', with: 'Incognito'
          fill_in 'Address', with: '1234 Fake St.'
          fill_in 'City', with: 'New York City'
          select 'New York', from: 'State'
          fill_in 'Zip', with: '10001'
          fill_in 'Telephone', with: '555-555-1234'

          # Use the default country
          # select 'United States', from: 'Country'

          click_button 'Save'
        end
      end

      expect(current_path).to eq '/checkout'

      within '[data-hook=opco-shipping-address]' do
        expect(page).to have_css('[data-hook=opco-address-book] .selected', count: 1, text: /1234 Fake St/)
        expect(page).to have_css('[data-hook=opco-existing-address]', count: 1, text: /1234 Fake St/)
        expect(page).to have_css('[data-hook=opco-new-address]', count: 1)
      end

      # Set expectation that both address books are updated
      within '[data-hook=opco-payment-method]' do
        expect(page).to have_css('[data-hook=opco-address-book] .selected', count: 1, text: /1234 Fake St/)
        expect(page).to have_css('[data-hook=opco-existing-address]', count: 1, text: /1234 Fake St/)
        expect(page).to have_css('[data-hook=opco-new-address]', count: 1)
      end

      # FIXME Remove these DMA expectations once the full spec is implemented?
      current_order.reload.ship_address.tap do |shipping_address|
        expect(shipping_address.lastname).to match(/Incognito/)
        expect(shipping_address.address1).to match(/1234 Fake St/)
      end

      # shipping_method.choose
      within '[data-hook=opco-shipping-method]' do
        find("option[value='#{shipping_method.id}']").select_option
      end

      expect(current_path).to eq '/checkout'

      # FIXME Remove these DMA expectations once the full spec is implemented?
      current_order.reload.shipping_method.tap do |shipping_method|
        expect(shipping_method).to eq shipping_method
      end

      # credit_card.create
      within '[data-hook=opco-payment-method]' do
        within '[data-hook=opco-new-credit-card]' do
          click_on 'Add Credit Card'

          fill_in 'Card Number', with: '4111111111111111'
          select '1', from: 'Expiration Month'
          select '2015', from: 'Expiration Year'
          fill_in 'Verification Value', with: '123'

          click_button 'Save'
        end
      end

      expect(current_path).to eq '/checkout'

      within '[data-hook=opco-payment-method]' do
        expect(page).to have_css('[data-hook=opco-existing-credit-card]', count: 1, text: /xxxx-xxxx-xxxx-1111/i)
        expect(page).to have_css('[data-hook=opco-new-credit-card]', count: 1)
      end

      current_order.reload.tap do |order|
        expect(order.payments).to have(1).item
        expect(order.payments.first.source.last_digits).to eq '1111'
      end

      within '[data-hook=opco-payment-method]' do
        within '[data-hook=opco-new-address]' do
          click_on 'Add Address'

          fill_in 'First Name', with: 'Guy'
          fill_in 'Last Name', with: 'Incognito'
          fill_in 'Address', with: '1234 Fake St.'
          fill_in 'City', with: 'New York City'
          select 'New York', from: 'State'
          fill_in 'Zip', with: '10001'
          fill_in 'Telephone', with: '555-555-1234'

          # Use the default country
          # select 'United States', from: 'Country'

          click_button 'Save'
        end
      end

      within '[data-hook=opco-payment-method]' do
        expect(page).to have_css('[data-hook=opco-address-book] .selected', count: 1, text: /1234 Fake St/)
        expect(page).to have_css('[data-hook=opco-existing-address]', count: 2, text: /1234 Fake St/)
        expect(page).to have_css('[data-hook=opco-new-address]', count: 1)
      end

      # FIXME Remove these DMA expectations once the full spec is implemented?
      current_order.reload.tap do |order|
        expect(order.bill_address.lastname).to match(/Incognito/)
        expect(order.bill_address.address1).to match(/1234 Fake St/)

        expect(order.payments).to have(1).item
      end

      # confirmation.confirm
      click_on 'Confirm My Order'

      sleep 5

      expect(page).to have_content %r{ORDER #[0-9A-Z]+}
      expect(current_path).to match %r{/orders/[0-9A-Z]+}

      current_order.reload.tap do |order|
        expect(order).to be_complete
      end
    end
  end

  context "with PayPal" do
    it "completes a checkout"
  end

  context "with store credit" do
    it "completes a checkout"
  end

  def pending_further_implementation!
    sleep 2
    pending "further implementation"
  end
end
