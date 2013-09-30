require 'spec_helper'

def register_widget
  has_widgets do |root|
    root << widget('one_page_checkout/payment_method', :opco_payment_method, user: current_user, order: current_order)
  end
end

module OnePageCheckout
  describe PaymentMethodWidget do
    register_widget

    let(:current_user) { double(:current_user, addresses: []) }
    let(:current_order) { double(:current_order) }

    let(:rendered) { render_widget(:opco_payment_method, :display) }

    it "renders the payment-details form" do
      expect(rendered).to have_selector("[data-hook=opco-payment-method]")
      expect(rendered).to have_selector("[data-hook=opco-payment-method] > [data-hook=opco-payment-details]")
    end

    it "renders the billing address-book" do
      expect(rendered).to have_selector("[data-hook=opco-payment-method]")
      expect(rendered).to have_selector("[data-hook=opco-payment-method] > [data-hook=opco-address-book]")
    end

    context "when receiving an :address_created event" do
      register_widget

      let(:payment_method_widget) { root.find_widget(:opco_payment_method) }
      let(:new_address) { double(:new_address) }

      before do
        current_order.stub(:update_attribute)
      end

      it "assigns the new address as the order's billing address" do
        expect(current_order).to receive(:update_attribute).with(:bill_address, new_address)

        trigger!
      end

      it "triggers a :billing_address_updated event" do
        expect(payment_method_widget).to receive(:trigger).with(:billing_address_updated)

        trigger!
      end


      def trigger!
        trigger(:address_created, :opco_payment_method, new_address: new_address)
      end
    end
  end
end
