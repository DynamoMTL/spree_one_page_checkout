class OnePageCheckout::AddressBook::PanelWidget < Apotomo::Widget
  has_widgets do |panel|
    user = options.fetch(:user)

    panel << widget('one_page_checkout/address_book/existing_address', :address_book_entry, user: user)
    panel << widget('one_page_checkout/address_book/new_address', :new_address_book_entry, user: user)
  end

  responds_to_event :address_created

  def initialize(parent, id, options = {})
    super(parent, id, options)

    @user = options.fetch(:user)
  end

  def display
    render
  end

  def address_created(event)
    replace state: :display
  end
end
