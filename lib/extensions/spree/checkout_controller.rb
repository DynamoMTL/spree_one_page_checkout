module Extensions
  module Spree
    module CheckoutController
      extend ActiveSupport::Concern

      included do
        prepend_before_filter :redirect_to_edit_checkout, only: [:update]

        def skip_state_validation?
          true
        end
      end

      private

      def redirect_to_edit_checkout
        redirect_to checkout_url and return
      end
    end
  end
end

::Spree::CheckoutController.send(:include, ::Extensions::Spree::CheckoutController)
