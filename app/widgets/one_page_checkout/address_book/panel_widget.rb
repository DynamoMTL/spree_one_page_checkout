class OnePageCheckout::AddressBook::PanelWidget < Apotomo::Widget
  responds_to_event :address_created

  has_widgets do |root|
    root << widget('one_page_checkout/address_book/existing_address', :address_book_entry)
    root << widget('one_page_checkout/address_book/new_address', :new_address_book_entry)
  end

  def display(options = {})
    assign_user(options)

    render
  end

  def address_created(event)
    replace({ state: :display }, event.data.fetch(:user))
  end

  private

  def assign_user(options)
    @user = Spree::User.find(options.fetch(:user))
  end
end
