module OnePageCheckout
  class ShippingAddressWidget < Apotomo::Widget
    has_widgets do |panel|
      panel << widget('one_page_checkout/address_book/panel', :opco_address_book, options.slice(:order, :user))
    end

    responds_to_event :address_created, with: :assign_address_to_order

    def initialize(parent, id, options = {})
      super(parent, id, options)

      @order = options.fetch(:order)
    end

    def display
      render
    end

    def assign_address_to_order(event)
      # FIXME Exposes internal structure of Order
      order.update_attribute(:ship_address, event.data.fetch(:new_address))

      trigger :shipping_address_updated
    end

    private

    attr_reader :order
  end
end
