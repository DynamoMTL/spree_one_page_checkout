class CreateCreditCard
  def initialize(credit_card_factory, credit_card_form)
    @credit_card_factory = credit_card_factory
    @credit_card_form    = credit_card_form
  end

  def call(attrs)
    return unless credit_card_form.validate(attrs)

    credit_card_form.save do |data, nested|
      @credit_card = credit_card_factory.create!(nested)
    end

    @credit_card
  end

  private

  attr_reader :credit_card_factory, :credit_card_form
end
