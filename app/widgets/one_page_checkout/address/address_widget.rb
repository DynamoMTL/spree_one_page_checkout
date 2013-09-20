class OnePageCheckout::Address::AddressWidget < Apotomo::Widget
  responds_to_event :reveal_form
  responds_to_event :create_address

  def display(address = nil)
    render
  end

  def form
    @form ||= new_address_form

    render
  end

  def call_to_action
    render
  end

  def create_address(event)
    if create_address_service(event.data.fetch(:address))
      replace state: :display
    else
      replace state: :form
    end
  end

  def reveal_form(event)
    replace state: :form
  end

  private

  # FIXME Uninjected collaborator
  def address_factory
    Spree::Address
  end

  # FIXME Uninjected collaborator
  def address_form_factory
    Forms::AddressForm
  end

  def create_address_service(attrs)
    return unless new_address_form.validate(attrs)

    new_address_form.save do |data, nested|
      @address = address_factory.create!(nested)
    end
  end

  def new_address_form
    @_form ||= address_form_factory.new(address_factory.new)
  end
end
