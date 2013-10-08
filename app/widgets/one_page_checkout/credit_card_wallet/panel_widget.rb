class OnePageCheckout::CreditCardWallet::PanelWidget < Apotomo::Widget
  has_widgets do |panel|
    panel << widget('one_page_checkout/credit_card_wallet/existing_credit_card',
                    :credit_card_entry,
                    options.slice(:order, :user))

    panel << widget('one_page_checkout/credit_card_wallet/new_credit_card',
                    :new_credit_card_entry,
                    options.slice(:order, :user))
  end

  responds_to_event :payment_created, with: :redraw_wallet, passing: :root

  def initialize(parent, id, options = {})
    super(parent, id, options)

    @current_credit_card = options.fetch(:current_credit_card, nil)
    @order               = options.fetch(:order)
    @user                = options.fetch(:user)
  end

  def display
    render
  end

  def redraw_wallet(event)
    @current_credit_card = event.data.fetch(:payment).source

    replace state: :display
  end

  private

  attr_reader :current_credit_card, :order
  helper_method :css_classes_for

  def css_classes_for(credit_card)
    [].tap do |classes|
      classes << 'selected' if current_credit_card.eql? credit_card
    end
  end
end

