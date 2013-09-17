class OnePageCheckout::Address::AddressWidget < Apotomo::Widget
  responds_to_event :add_address

  def display
    render
  end

  def form
    render
  end

  def call_to_action
    render
  end

  def add_address(event)
    replace state: :form
  end
end
