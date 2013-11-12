module OnePageCheckout
  class ShippingAddressWidget < Apotomo::Widget
    has_widgets do |panel|
      panel << widget('one_page_checkout/shipping_address_book/panel',
                      :opco_shipping_address_book,
                      options.slice(:current_address, :order, :user))
    end

    responds_to_event :address_created, with: :assign_address_to_order
    responds_to_event :assign_address, with: :assign_address_to_order

    def initialize(parent, id, options = {})
      super(parent, id, options)

      @address_repository = options.fetch(:address_repository, Spree::Address)
      @current_address = options.fetch(:current_address, nil)
      @order = options.fetch(:order)
    end

    def display
      render
    end

    def assign_address_to_order(event)
      address = address_repository.find(event.data.fetch(:address))

      # FIXME Exposes internal structure of Order
      order.update_attribute(:ship_address, address)
      order.update_attribute(:bill_address, address) unless order.bill_address
      order.remove_invalid_shipments!
      order.create_tax_charge!

      trigger(:shipping_address_updated, { address: address })
    end

    private

    attr_reader :address_repository, :current_address, :order
    helper_method :current_address
  end
end
