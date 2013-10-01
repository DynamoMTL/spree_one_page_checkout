require 'spec_helper'

def register_widget
  has_widgets do |root|
    root << widget('one_page_checkout/payment_method', :opco_payment_method, user: current_user, order: current_order)
  end
end

module OnePageCheckout
  describe PaymentMethodWidget do
    register_widget

    let(:current_user) { double(:current_user, addresses: [], credit_cards: []) }
    let(:current_order) { double(:current_order) }

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

    context "when receiving a :credit_card_created event" do
      register_widget

      let(:payment_method_widget) { root.find_widget(:opco_payment_method) }

      # let(:payment_form) { double(:payment_form) }
      # let(:create_payment_service) { double(:create_payment_service)}

      let(:new_credit_card) { double(:new_credit_card) }

      let(:new_payment) { double(:new_payment) }

      let(:order_total) { double(:order_total) }

      let(:payment_source_attrs) { double(:payment_source_attrs).as_null_object }
      let(:payments_collection) { double(:payments_collection) }
      let(:payment_method) { double(:payment_method, id: payment_method_id) }
      let(:payment_method_id) { double(:payment_method_id) }

      before do
        # CreatePaymentFactory.stub(:build).and_return(create_payment_service)
        # Forms::PaymentForm.stub(:new).and_return(payment_form)
        Spree::PaymentMethod.stub(:first).and_return(payment_method)

        # payment_method_widget.stub(:replace)
        # payment_method_widget.stub(:trigger)
        # create_payment_service.stub(:call)
        current_order.stub(:payments).and_return(payments_collection)
        current_order.stub(:total).and_return(order_total)
      end

      context "with a valid payment submission" do
        register_widget

        before do
          # create_payment_service.stub(:call).and_return(new_payment)
          payments_collection.stub(:create!).and_return(new_payment)
        end

        it "creates a new payment on the order" do
          expect(payments_collection).to receive(:create!) do |payment_attrs|
            expect(payment_attrs[:amount]).to eq order_total
            expect(payment_attrs[:payment_method_id]).to eq payment_method_id
            expect(payment_attrs[:source]).to eq new_credit_card
          end

          trigger!
        end

        it "triggers a :payment_created event" do
          expect(payment_method_widget).to receive(:trigger).with(:payment_created, payment: new_payment)

          trigger!
        end
      end

      context "with an invalid payment submission" do
        register_widget

        before do
          # create_payment_service.stub(:call).and_return(false)
          payments_collection.stub(:create!).and_return(false)
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
