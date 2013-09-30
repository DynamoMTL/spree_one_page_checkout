class OnePageCheckout::ShippingMethodWidget < Apotomo::Widget
  include ActionView::Helpers::FormOptionsHelper

  responds_to_event :shipping_address_updated, passing: :root
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

  def shipping_address_updated(event)
    replace state: :display
  end

  def choose_shipping_method(event)
    # FIXME Exposes internal structure of Order
    order.update_attribute(:shipping_method_id, event.data.fetch(:shipping_method_id))

    replace state: :display
  end

  private

  attr_reader :order
  helper_method :shipping_method_options

  def shipping_methods
    # FIXME Exposes internal structure of Order
    @_shipping_methods ||= order.rate_hash
  end

  def shipping_method_options
    @_shipping_method_options ||=
      options_from_collection_for_select(shipping_methods, :id, :name)
  end
end
