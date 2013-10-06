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

    def display(current_address = nil)
      @current_address = current_address

      render
    end

    def shipping_address_updated(event)
      replace({state: :display}, event.data.fetch(:address))
    end
  end
end
