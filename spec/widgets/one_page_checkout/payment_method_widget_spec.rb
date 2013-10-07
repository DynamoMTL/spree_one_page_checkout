require 'spec_helper'

def register_widget
  has_widgets do |root|
    root << widget('one_page_checkout/payment_method',
                   :opco_payment_method,
                   address_repository: address_repository,
                   current_address: current_address,
                   order: current_order,
                   user: current_user)
  end
end

module OnePageCheckout
  describe PaymentMethodWidget do
    register_widget

    let(:address_repository) { double(:address_repository) }
    let(:current_address) { double(:current_address) }
    let(:current_order) { double(:current_order) }
    let(:current_user) { double(:current_user, addresses: [], credit_cards: []) }

    let(:rendered) { render_widget(:opco_payment_method, :display) }

    it "renders the credit-card wallet" do
      expect(rendered).to have_selector("[data-hook=opco-payment-method]")
      expect(rendered).to have_selector("[data-hook=opco-payment-method] > [data-hook=opco-credit-card-wallet]")
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
        address_repository.stub(:find).with(new_address).and_return(new_address)
        current_order.stub(:update_attribute)
      end

      it "assigns the new address as the order's billing address" do
        expect(current_order).to receive(:update_attribute).with(:bill_address, new_address)

        trigger!
      end

      it "triggers a :billing_address_updated event" do
        expect(payment_method_widget).to receive(:trigger).with(:billing_address_updated, address: new_address)

        trigger!
      end

      def trigger!
        trigger(:address_created, :opco_payment_method, address: new_address)
      end
    end

    context "when receiving an :assign_address event" do
      register_widget

      let(:new_address) { double(:new_address) }
      let(:payment_method_widget) { root.find_widget(:opco_payment_method) }

      before do
        address_repository.stub(:find).with(new_address).and_return(new_address)
        current_order.stub(:update_attribute)
      end

      it "assigns the new address as the order's billing address" do
        expect(current_order).to receive(:update_attribute).with(:bill_address, new_address)

        trigger!
      end

      it "triggers a :billing_address_updated event" do
        expect(payment_method_widget).to receive(:trigger).with(:billing_address_updated, address: new_address)

        trigger!
      end

      def trigger!
        trigger(:assign_address, :opco_payment_method, address: new_address)
      end
    end

    context "when receiving a :credit_card_created event" do
      register_widget

      let(:payment_method_widget) { root.find_widget(:opco_payment_method) }

      let(:create_payment_service) { double(:create_payment_service)}
      let(:new_credit_card) { double(:new_credit_card) }
      let(:new_payment) { double(:new_payment) }
      let(:order_total) { double(:order_total) }

      before do
        CreatePaymentFactory.stub(:build).with(current_order).and_return(create_payment_service)

        create_payment_service.stub(:call)
        current_order.stub(:total).and_return(order_total)
      end

      it "attempts to create a new payment on the order" do
        expect(create_payment_service).to receive(:call).with(order_total, new_credit_card)

        trigger!
      end

      context "with a valid payment submission" do
        register_widget

        before do
          create_payment_service.stub(:call).and_return(new_payment)
        end

        it "triggers a :payment_created event" do
          expect(payment_method_widget).to receive(:trigger).with(:payment_created, payment: new_payment)

          trigger!
        end
      end

      context "with an invalid payment submission" do
        register_widget

        before do
          create_payment_service.stub(:call).and_return(false)
        end

        it "redraws the :display state" do
          expect(payment_method_widget).to receive(:replace) do |state_or_view, args|
            expect(state_or_view).to eq(state: :display)
          end

          trigger!
        end
      end

      def trigger!
        trigger(:credit_card_created, :opco_payment_method, credit_card: new_credit_card)
      end
    end
  end
end
