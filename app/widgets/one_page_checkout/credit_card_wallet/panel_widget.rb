class OnePageCheckout::CreditCardWallet::PanelWidget < Apotomo::Widget
  has_widgets do |panel|
    panel << widget('one_page_checkout/credit_card_wallet/existing_credit_card',
                    :credit_card_entry,
                    options.slice(:order, :user))

    panel << widget('one_page_checkout/credit_card_wallet/new_credit_card',
                    :new_credit_card_entry,
                    options.slice(:order, :user))
  end

  responds_to_event :credit_card_created

  def initialize(parent, id, options = {})
    super(parent, id, options)

    @order  = options.fetch(:order)
    @user   = options.fetch(:user)
  end

  def display
    render
  end

  def credit_card_created(event)
    replace state: :display
  end

  private

  attr_reader :order
end

