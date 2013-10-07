require 'spec_helper'

def register_widget
  has_widgets do |root|
    root << widget('one_page_checkout/shipping_method', :opco_shipping_method, user: current_user, order: current_order)
  end
end

module OnePageCheckout
  describe ShippingMethodWidget do
    register_widget

    let!(:shipping_method_widget) { root.find_widget(:opco_shipping_method) }

    let(:current_user) { create(:user) }
    let(:current_order) { create(:order) }

    let(:rendered) { render_widget(:opco_shipping_method, :display) }

    it "renders the shipping-method selection dropdown" do
      expect(rendered).to have_selector("[data-hook=opco-shipping-method]")
    end

    context "when receiving an :shipping_address_updated event" do
      register_widget

      it "redraws the :display state" do
        expect(shipping_method_widget).to receive(:replace) do |state_or_view, args|
          expect(state_or_view).to eq(state: :display)
        end

        trigger!
      end

      def trigger!
        trigger(:shipping_address_updated, :opco_shipping_method)
      end
    end

    context "when receiving a :choose_shipping_method event" do
      register_widget

      let(:shipping_method_id) { double(:shipping_method_id) }

      before do
        current_order.stub(:update_attribute)
        current_order.stub(:create_shipment!)
      end

      it "assigns the shipping-method to the order" do
        expect(current_order).to receive(:update_attribute).with(:shipping_method_id, shipping_method_id)

        trigger!
      end

      it "creates a shipment for the order" do
        expect(current_order).to receive(:create_shipment!).once

        trigger!
      end

      it "triggers a :shipping_method_updated event" do
        expect(shipping_method_widget).to receive(:trigger).with(:shipping_method_updated)

        trigger!
      end

      def trigger!
        trigger(:choose_shipping_method, :opco_shipping_method, shipping_method_id: shipping_method_id)
      end
    end
  end
end
