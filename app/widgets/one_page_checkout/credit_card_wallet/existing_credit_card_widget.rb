module OnePageCheckout::CreditCardWallet
  class ExistingCreditCardWidget < Apotomo::Widget
    def display(credit_card = nil)
      @credit_card = credit_card

      render
    end
  end
end
