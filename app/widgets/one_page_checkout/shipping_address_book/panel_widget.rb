module OnePageCheckout
  class ShippingAddressBook::PanelWidget < AddressBook::PanelWidget
    has_widgets do |panel|
      panel << widget('one_page_checkout/address_book/existing_address',
                      :shipping_address_book_entry,
                      options.slice(:order, :user))

      panel << widget('one_page_checkout/address_book/new_address',
                      :new_shipping_address_book_entry,
                      options.slice(:order, :user))
    end

    responds_to_event :shipping_address_updated, passing: :root
    responds_to_event :billing_address_updated, passing: :root

    def shipping_address_updated(event)
      @current_address = event.data.fetch(:address)

      replace state: :display
    end

    def billing_address_updated(event)
      # FIXME Wrong place, untested
      @current_address = order.reload.ship_address

      replace state: :display
    end
  end
end
