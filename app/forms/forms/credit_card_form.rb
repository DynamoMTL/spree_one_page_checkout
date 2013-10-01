module Forms
  class CreditCardForm < Reform::Form
    model :credit_card

    properties %w(
      month
      number
      user_id
      verification_value
      year
    )

    validates :month, :number,
      :verification_value, :year, presence: true
  end
end
