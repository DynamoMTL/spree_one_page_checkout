class OnePageCheckout::AddressBook::PanelWidget < Apotomo::Widget
  has_widgets do |panel|
    panel << widget('one_page_checkout/address_book/existing_address',
                    existing_address_widget_id,
                    options.slice(:order, :user))

    panel << widget('one_page_checkout/address_book/new_address',
                    new_address_widget_id,
                    options.slice(:order, :user))
  end

  responds_to_event :address_created

  def initialize(parent, id, options = {})
    super(parent, id, options)

    @order  = options.fetch(:order)
    @prefix = options.fetch(:prefix, 'generic')
    @user   = options.fetch(:user)
  end

  def display
    render
  end

  def address_created(event)
    replace state: :display
  end

  private

  attr_reader :order
  helper_method :existing_address_widget_id, :new_address_widget_id

  def existing_address_widget_id
    :"#{prefix}_address_book_entry"
  end

  def new_address_widget_id
    :"new_#{prefix}_address_book_entry"
  end

  def prefix
    @prefix || options.fetch(:prefix, 'generic')
  end
end
