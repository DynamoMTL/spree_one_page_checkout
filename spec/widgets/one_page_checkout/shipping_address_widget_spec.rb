require 'spec_helper'

def register_widget
  has_widgets do |root|
    root << widget('one_page_checkout/shipping_address', :opco_shipping_address, user: current_user, order: current_order)
  end
end

module OnePageCheckout
  describe ShippingAddressWidget do
    register_widget

    let(:current_user) { double(:current_user, addresses: []) }
    let(:current_order) { double(:current_order) }

    let(:rendered) { render_widget(:opco_shipping_address, :display) }

    it "renders the shipping-address address-book" do
      expect(rendered).to have_selector("[data-hook=opco-shipping-address]")
      expect(rendered).to have_selector("[data-hook=opco-shipping-address] > [data-hook=opco-address-book]")
    end
  end
end
