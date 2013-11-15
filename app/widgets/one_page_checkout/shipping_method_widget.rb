class OnePageCheckout::ShippingMethodWidget < Apotomo::Widget
  include ActionView::Helpers::FormOptionsHelper

  responds_to_event :billing_address_updated, with: :redraw, passing: :root
  responds_to_event :shipping_address_updated, with: :redraw, passing: :root
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

  def redraw(event)
    replace state: :display
  end

  def choose_shipping_method(event)
    # FIXME Exposes internal structure of Order
    order.update_attribute(:shipping_method_id, event.data.fetch(:shipping_method_id))
    order.create_shipment!
    order.create_tax_charge!

    trigger :shipping_method_updated
  end

  private

  attr_reader :order
  helper_method :order, :shipping_rates

  def current_shipping_method
    # FIXME Exposes internal structure of Order
    order.shipping_method_id
  end

  def shipping_rates
    # FIXME Exposes internal structure of Order
    @_shipping_rates ||= order.rate_hash
  end

  def shipping_method_options
    @_shipping_method_options ||=
      options_from_collection_for_select(shipping_methods, :id, :name, current_shipping_method)
  end
end
