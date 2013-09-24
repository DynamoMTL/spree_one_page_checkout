module Extensions
  module Spree
    module CheckoutController
      extend ActiveSupport::Concern

      included do
        prepend_before_filter :redirect_to_edit_checkout, only: [:update, :edit], if: :redirect_to_edit?

        has_widgets do |root|
          root << widget('one_page_checkout/address_book/panel', :opco_address_book, user: spree_current_user)
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
