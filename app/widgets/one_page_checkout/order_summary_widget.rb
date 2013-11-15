module OnePageCheckout
  class OrderSummaryWidget < Apotomo::Widget
    helper Spree::BaseHelper
    helper Spree::OrdersHelper

    responds_to_event :billing_address_updated, with: :redraw, passing: :root
    responds_to_event :shipping_address_updated, with: :redraw, passing: :root
    responds_to_event :shipping_method_updated, with: :redraw, passing: :root

    def initialize(parent, id, options = {})
      super(parent, id, options)

      @order = options.fetch(:order)
    end

    def display
      render
    end

    def redraw
      order.reload

      replace state: :display
    end

    private

    attr_reader :order
    helper_method :order
  end
end
