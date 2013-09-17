class OnePageCheckout::Address::AddressWidget < Apotomo::Widget
  responds_to_event :reveal_form

  def display
    render
  end

  def form
    render
  end

  def call_to_action
    render
  end

  def reveal_form(event)
    replace state: :form
  end
end
