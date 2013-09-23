class CreateAddressFactory
  def self.build(address_form, *args)
    new(address_form).build(*args)
  end

  def initialize(address_form)
    @address_form = address_form
  end

  def build
    return create_address
  end

  private

  attr_reader :address_form

  def create_address
    @_create_address ||= CreateAddress.new(address_factory, address_form)
  end

  def address_factory
    @_address_factory ||= Spree::Address
  end
end
