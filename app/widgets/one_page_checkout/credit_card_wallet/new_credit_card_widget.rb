module OnePageCheckout::CreditCardWallet
  class NewCreditCardWidget < Apotomo::Widget
    responds_to_event :reveal_form
    responds_to_event :create_credit_card

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

    def create_credit_card(event)
      if credit_card = create_credit_card_service.call(event.data.fetch(:credit_card))
        trigger :credit_card_created, credit_card: credit_card
      else
        replace state: :form
      end
    end

    def reveal_form(event)
      replace state: :form
    end

    private

    attr_reader :user
    helper_method :credit_card_form, :user

    def credit_card_form_factory
      Forms::CreditCardForm
    end

    def credit_card_form
      @_credit_card_form ||= credit_card_form_factory.new(Spree::CreditCard.new)
    end

    def create_credit_card_service
      @_create_credit_card_service = CreateCreditCardFactory.build(credit_card_form)
    end
  end
end
