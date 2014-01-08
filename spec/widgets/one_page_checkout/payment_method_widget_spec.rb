require 'spec_helper'

def register_widget
  has_widgets do |root|
    root << widget('one_page_checkout/payment_method',
                   :opco_payment_method,
                   address_repository: address_repository,
                   credit_card_repository: credit_card_repository,
                   current_address: current_address,
                   order: current_order,
                   user: current_user)
  end
end

module OnePageCheckout
  describe PaymentMethodWidget do
    register_widget

    let(:address_repository) { double(:address_repository) }
    let(:credit_card_repository) { double(:credit_card_repository) }
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

    it "renders the payment-gateway notifications panel" do
      expect(rendered).to have_selector("[data-hook=opco-payment-method]")
      expect(rendered).to have_selector("[data-hook=opco-payment-method] > [data-hook=opco-gateway-notifications]")
    end

    context "when receiving an :address_created event" do
      register_widget

      let(:payment_method_widget) { root.find_widget(:opco_payment_method) }
      let(:new_address) { double(:new_address) }

      before do
        address_repository.stub(:find).with(new_address).and_return(new_address)
        current_order.stub(:update_attribute)
        current_order.stub(:ship_address).and_return(double)
      end

      it "assigns the new address as the order's billing address" do
        expect(current_order).to receive(:update_attribute).with(:bill_address, new_address)

        trigger!
      end

      it "triggers a :billing_address_updated event" do
        expect(payment_method_widget).to receive(:trigger).with(:billing_address_updated, address: new_address)

        trigger!
      end

      context "without a shipping address assigned" do
        register_widget

        before do
          current_order.stub(:create_tax_charge!)
          current_order.stub(:remove_invalid_shipments!)
          current_order.stub(:ship_address).and_return(false)
        end

        it "assigns the new address as the order's shipping address" do
          expect(current_order).to receive(:update_attribute).with(:ship_address, new_address)

          trigger!
        end

        it "removes invalid shipments" do
          expect(current_order).to receive(:remove_invalid_shipments!)

          trigger!
        end

        it "creates tax charges" do
          expect(current_order).to receive(:create_tax_charge!)

          trigger!
        end
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
        current_order.stub(:ship_address).and_return(double)
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

      # TODO Under what conditions does this happen?
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

      context "with an invalid payment source" do
        register_widget

        let(:gateway_error) { Spree::Core::GatewayError }

        before do
          create_payment_service.stub(:call).and_raise(gateway_error)
          new_credit_card.stub(:destroy)
        end

        it "destroys the new credit card" do
          expect(new_credit_card).to receive(:destroy)

          trigger!
        end

        it "triggers a :gateway_error_raised event" do
          expect(payment_method_widget).to receive(:trigger)
            .with(:gateway_error_raised, gateway_error: an_instance_of(gateway_error))

          trigger!
        end
      end

      def trigger!
        trigger(:credit_card_created, :opco_payment_method, credit_card: new_credit_card)
      end
    end

    context "when receiving an :assign_credit_card event" do
      register_widget

      let(:payment_method_widget) { root.find_widget(:opco_payment_method) }

      let(:credit_card) { double(:credit_card) }
      let(:credit_card_id) { double(:credit_card_id) }
      let(:order_payments) { double(:order_payments) }

      before do
        credit_card_repository.stub(:find).with(credit_card_id).and_return(credit_card)
        current_order.stub(:payments).and_return(order_payments)
        order_payments.stub(:destroy_all)
        payment_method_widget.stub(:trigger)
      end

      it "clears existing payments on the order" do
        expect(order_payments).to receive(:destroy_all)

        trigger!
      end

      it "triggers a :credit_card_assigned event" do
        expect(payment_method_widget).to receive(:trigger)
          .with(:credit_card_assigned, credit_card: credit_card)

        trigger!
      end

      def trigger!
        trigger(:assign_credit_card, :opco_payment_method, credit_card: credit_card_id)
      end
    end

    context "when receiving a :credit_card_assigned event" do
      register_widget

      let(:payment_method_widget) { root.find_widget(:opco_payment_method) }

      let(:create_payment_service) { double(:create_payment_service)}
      let(:existing_credit_card) { double(:existing_credit_card) }
      let(:new_payment) { double(:new_payment) }
      let(:order_total) { double(:order_total) }

      before do
        CreatePaymentFactory.stub(:build).with(current_order).and_return(create_payment_service)

        create_payment_service.stub(:call)
        current_order.stub(:total).and_return(order_total)
      end

      it "attempts to create a new payment on the order" do
        expect(create_payment_service).to receive(:call).with(order_total, existing_credit_card)

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

      # TODO Under what conditions does this happen?
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

      context "with an invalid payment source" do
        register_widget

        let(:gateway_error) { Spree::Core::GatewayError }

        before do
          create_payment_service.stub(:call).and_raise(gateway_error)
        end

        it "triggers a :gateway_error_raised event" do
          expect(payment_method_widget).to receive(:trigger)
            .with(:gateway_error_raised, gateway_error: an_instance_of(gateway_error))

          trigger!
        end
      end

      def trigger!
        trigger(:credit_card_assigned, :opco_payment_method, credit_card: existing_credit_card)
      end
    end
  end
end
