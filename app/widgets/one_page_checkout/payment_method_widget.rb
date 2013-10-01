module OnePageCheckout
  class PaymentMethodWidget < Apotomo::Widget
    has_widgets do |panel|
      panel << widget('one_page_checkout/address_book/panel',
                      :opco_billing_address_book,
                      options.slice(:order, :user).merge(prefix: :billing))
    end

    responds_to_event :address_created, with: :assign_address_to_order
    responds_to_event :create_payment

    def initialize(parent, id, options = {})
      super(parent, id, options)

      @order = options.fetch(:order)
      @user = options.fetch(:user)
    end

    def display
      render
    end

    def assign_address_to_order(event)
      # FIXME Exposes internal structure of Order
      order.update_attribute(:bill_address, event.data.fetch(:new_address))

      trigger :billing_address_updated
    end

    def create_payment(event)
      attrs = event.data.fetch(:payment_source).with_indifferent_access

      payment = order.payments.create!(
        amount: order.total,
        payment_method_id: Spree::PaymentMethod.first.id,
        source_attributes: {
          number: attrs[:card_number],
          month: attrs[:expiration_month],
          year: attrs[:expiration_year],
          verification_value: attrs[:verification_value]
        }
      )

      if payment
        trigger :payment_created, new_payment: payment
      else
        replace state: :display
      end
    end

    private

    attr_reader :order
  end
end
