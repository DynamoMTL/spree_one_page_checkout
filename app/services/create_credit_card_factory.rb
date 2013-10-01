class CreateCreditCardFactory
  def self.build(credit_card_form, *args)
    new(credit_card_form).build(*args)
  end

  def initialize(credit_card_form)
    @credit_card_form = credit_card_form
  end

  def build
    return create_credit_card
  end

  private

  attr_reader :credit_card_form

  def create_credit_card
    @_create_credit_card ||= CreateCreditCard.new(credit_card_factory, credit_card_form)
  end

  def credit_card_factory
    @_credit_card_factory ||= Spree::CreditCard
  end
end
