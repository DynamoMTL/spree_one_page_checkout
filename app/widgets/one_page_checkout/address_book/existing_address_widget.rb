module OnePageCheckout::AddressBook
  class ExistingAddressWidget < Apotomo::Widget
    def display(address = nil)
      @address = address

      render
    end
  end
end
