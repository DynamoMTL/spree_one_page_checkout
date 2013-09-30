module OnePageCheckout
  class ShippingAddressWidget < Apotomo::Widget
    has_widgets do |panel|
      panel << widget('one_page_checkout/address_book/panel', :opco_address_book, options.slice(:order, :user))
    end

    def display
      render
    end
  end
end
