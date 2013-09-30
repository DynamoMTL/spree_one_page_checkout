class OnePageCheckout::ShippingMethodWidget < Apotomo::Widget
  responds_to_event :address_chosen, passing: :root
  responds_to_event :choose_shipping_method

  def initialize(parent, id, options = {})
    super(parent, id, options)

    @order = options.fetch(:order)
    @user = options.fetch(:user)
  end

  def display
    order.reload

    render
  end

  def address_chosen(event)
    replace state: :display
  end

  def choose_shipping_method(event)
    order.update_attribute(:shipping_method_id, event.data.fetch(:shipping_method_id))

    replace state: :display
  end

  private

  attr_reader :order, :user
  helper_method :order
end
