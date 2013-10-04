module OnePageCheckout
  class PaymentMethodWidget < Apotomo::Widget
    has_widgets do |panel|
      panel << widget('one_page_checkout/credit_card_wallet/panel',
                      :opco_credit_card_wallet,
                      options.slice(:order, :user))

      panel << widget('one_page_checkout/address_book/panel',
                      :opco_billing_address_book,
                      options.slice(:order, :user).merge(prefix: :billing))
    end

    responds_to_event :address_created, with: :assign_address_to_order
    responds_to_event :credit_card_created, with: :create_payment_using_credit_card

    def initialize(parent, id, options = {})
      super(parent, id, options)

      @address_repository = options.fetch(:address_repository, Spree::Address)
      @order = options.fetch(:order)
      @user = options.fetch(:user)
    end

    def display
      render
    end

    def assign_address_to_order(event)
      address = address_repository.find(event.data.fetch(:address))

      # FIXME Exposes internal structure of Order
      order.update_attribute(:bill_address, address)

      trigger :billing_address_updated, address: address
    end

    def create_payment_using_credit_card(event)
      if payment = create_payment_service.call(order.total, event.data.fetch(:credit_card))
        trigger :payment_created, payment: payment
      else
        replace state: :display
      end
    end

    private

    attr_reader :address_repository, :order

    def create_payment_service
      @_create_payment_service = CreatePaymentFactory.build(order)
    end
  end
end
