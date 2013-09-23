class CreateAddress
  def initialize(address_factory, address_form)
    @address_factory = address_factory
    @address_form    = address_form
  end

  def call(attrs)
    return unless address_form.validate(attrs)

    address_form.save do |data, nested|
      @address = address_factory.create!(nested)
    end

    @address
  end

  private

  attr_reader :address_factory, :address_form
end
