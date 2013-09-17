module Extensions
  module Spree
    module OrdersController
      extend ActiveSupport::Concern

      def checkout_state_path(*args)
        checkout_path
      end
    end
  end
end

::Spree::OrdersController.send(:include, ::Extensions::Spree::OrdersController)
