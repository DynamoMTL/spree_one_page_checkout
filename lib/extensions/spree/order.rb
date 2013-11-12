module Extensions
  module Spree
    module Order
      extend ActiveSupport::Concern

      included do
        register_update_hook :assign_default_credit_card
        register_update_hook :synchronize_payment_amount
      end

      def assign_default_credit_card
        return if payments.present?

        if user && user.credit_cards.any?
          CreatePaymentFactory.build(self).call(total, user.credit_cards.last)
        end
      end

      def synchronize_payment_amount
        return if complete? || payments_in_sync? || payments.empty?
        payments.last.update_column(:amount, total)
      end

      private

      def payments_in_sync?
        payments.present? && payments.sum(&:amount) == total
      end

    end
  end
end
::Spree::Order.send(:include, ::Extensions::Spree::Order)
