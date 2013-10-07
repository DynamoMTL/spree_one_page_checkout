module OnePageCheckout
  class BillingAddressBook::PanelWidget < AddressBook::PanelWidget
    has_widgets do |panel|
      panel << widget('one_page_checkout/address_book/existing_address',
                      :billing_address_book_entry,
                      options.slice(:order, :user))

      panel << widget('one_page_checkout/address_book/new_address',
                      :new_billing_address_book_entry,
                      options.slice(:order, :user))
    end

    responds_to_event :billing_address_updated, passing: :root
    responds_to_event :shipping_address_updated, passing: :root

    def billing_address_updated(event)
      @current_address = event.data.fetch(:address)

      replace state: :display
    end

    def shipping_address_updated(event)
      replace state: :display
    end
  end
end
