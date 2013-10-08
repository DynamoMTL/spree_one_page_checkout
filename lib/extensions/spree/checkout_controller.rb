module Extensions
  module Spree
    module CheckoutController
      extend ActiveSupport::Concern

      included do
        prepend_before_filter :redirect_to_edit_checkout, only: [:update, :edit], if: :redirect_to_edit?

        has_widgets do |root|
          root << widget('one_page_checkout/order_summary', :opco_order_summary, user: spree_current_user, order: current_order, current_address: current_order.ship_address)
          root << widget('one_page_checkout/shipping_address', :opco_shipping_address, user: spree_current_user, order: current_order, current_address: current_order.ship_address)
          root << widget('one_page_checkout/shipping_method', :opco_shipping_method, user: spree_current_user, order: current_order)
          root << widget('one_page_checkout/payment_method', :opco_payment_method, user: spree_current_user, order: current_order, current_address: current_order.bill_address, current_credit_card: current_order.payments.valid.first.try(:source))
          root << widget('one_page_checkout/confirm_order', :opco_confirm_order, order: current_order)
        end

        def skip_state_validation?
          true
        end
      end

      private

      def redirect_to_edit_checkout
        redirect_to checkout_url and return
      end

      def redirect_to_edit?
        params.include?(:state) || params[:action] == 'update'
      end
    end
  end
end

::Spree::CheckoutController.send(:include, ::Extensions::Spree::CheckoutController)
