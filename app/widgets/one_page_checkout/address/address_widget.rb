class OnePageCheckout::Address::AddressWidget < Apotomo::Widget
  responds_to_event :reveal_form
  responds_to_event :create_address

  def display(address = nil)
    render
  end

  def form
    @form ||= Forms::AddressForm.new(Spree::Address.new)

    render
  end

  def call_to_action
    render
  end

  def create_address(event)
    form = Forms::AddressForm.new(Spree::Address.new)

    if form.validate(event.data.fetch(:address))
      form.save do |data, nested|
        @address = Spree::Address.create!(nested)
      end

      replace state: :display
    else
      replace state: :form
    end

  end

  def reveal_form(event)
    replace state: :form
  end
end
