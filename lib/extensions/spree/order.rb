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

      # Clear shipment when transitioning to delivery step of checkout if the
      # current shipping address is not eligible for the existing shipping method
      def remove_invalid_shipments!
        shipments.each { |s| s.destroy unless s.shipping_method.available_to_order?(self) }
      end

          # Creates a new shipment (adjustment is created by shipment model)
    # def create_shipment!
    #   shipping_method(true)
    #   if shipment.present?
    #     shipment.update_attributes!({:shipping_method => shipping_method, :inventory_units => self.inventory_units}, :without_protection => true)
    #   else
    #     self.shipments << Shipment.create!({ :order => self,
    #                                       :shipping_method =>   ,
    #                                       :address => self.ship_address,
    #                                       :inventory_units => self.inventory_units}, :without_protection => true)
    #   end
    # end

      private

      def payments_in_sync?
        payments.present? && payments.sum(&:amount) == total
      end

    end
  end
end
::Spree::Order.send(:include, ::Extensions::Spree::Order)
