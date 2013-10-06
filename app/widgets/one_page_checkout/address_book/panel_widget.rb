class OnePageCheckout::AddressBook::PanelWidget < Apotomo::Widget
  has_widgets do |panel|
    panel << widget('one_page_checkout/address_book/existing_address',
                    :address_book_entry,
                    options.slice(:order, :user))

    panel << widget('one_page_checkout/address_book/new_address',
                    :new_address_book_entry,
                    options.slice(:order, :user))
  end

  responds_to_event :address_created

  def initialize(parent, id, options = {})
    super(parent, id, options)

    @order  = options.fetch(:order)
    @prefix = options.fetch(:prefix, 'generic')
    @user   = options.fetch(:user)
  end

  def display(current_address = nil)
    @current_address = current_address

    render
  end

  def address_created(event)
    replace state: :display
  end

  private

  attr_reader :current_address, :order
  helper_method :css_classes_for

  def css_classes_for(address)
    [].tap do |classes|
      classes << 'selected' if current_address.eql? address
    end
  end
end
