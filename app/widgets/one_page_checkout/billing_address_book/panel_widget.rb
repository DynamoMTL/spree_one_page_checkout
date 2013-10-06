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

    def display(current_address = nil)
      @current_address = current_address

      render
    end

    def billing_address_updated(event)
      replace({state: :display}, event.data.fetch(:address))
    end
  end
end
