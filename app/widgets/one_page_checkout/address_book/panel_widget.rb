class OnePageCheckout::AddressBook::PanelWidget < Apotomo::Widget
  has_widgets do |panel|
    user = options.fetch(:user)

    panel << widget('one_page_checkout/address_book/existing_address', :address_book_entry, user: user)
    panel << widget('one_page_checkout/address_book/new_address', :new_address_book_entry, user: user)
  end

  responds_to_event :address_created

  def initialize(parent, id, options = {})
    super(parent, id, options)

    @order = options.fetch(:order)
    @user = options.fetch(:user)
  end

  def display
    render
  end

  def address_created(event)
    order.ship_address = event.data.fetch(:new_address)
    order.save!

    replace state: :display
  end

  private

  attr_reader :order
end
