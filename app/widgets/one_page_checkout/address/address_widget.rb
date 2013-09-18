class OnePageCheckout::Address::AddressWidget < Apotomo::Widget
  responds_to_event :reveal_form
  responds_to_event :create_address

  def display
    render
  end

  def form
    render
  end

  def call_to_action
    render
  end

  def create_address(event)
    create_address = create_address_factory.build
    create_address.call

    replace state: :display
  end

  def reveal_form(event)
    replace state: :form
  end

  def create_address_factory
    @_create_address_factory ||= CreateAddressFactory
  end
end
