class OnePageCheckout::AddressBook::NewAddressWidget < Apotomo::Widget
  responds_to_event :reveal_form
  responds_to_event :create_address

  def initialize(parent, id, options = {})
    super(parent, id, options)

    @user = options.fetch(:user)
  end

  def form
    render
  end

  def call_to_action
    render
  end

  def create_address(event)
    if address = create_address_service.call(event.data.fetch(:address))
      trigger :address_created, address: address
    else
      replace state: :form
    end
  end

  def reveal_form(event)
    replace state: :form
  end

  private

  attr_reader :user
  helper_method :address_form, :user

  def address_form_factory
    Forms::AddressForm
  end

  def address_form
    @_address_form ||= address_form_factory.new(Spree::Address.new)
  end

  def create_address_service
    @_create_address_service = CreateAddressFactory.build(address_form)
  end
end
