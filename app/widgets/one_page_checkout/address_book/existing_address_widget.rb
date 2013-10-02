module OnePageCheckout::AddressBook
  class ExistingAddressWidget < Apotomo::Widget
    def display(address, selected)
      @address = address
      @selected = selected

      render
    end

    private

    attr_reader :address
    helper_method :css_classes

    def css_classes
      [].tap do |classes|
        classes << ('selected' if is_selected?)
      end
    end

    def is_selected?
      @selected
    end
  end
end
