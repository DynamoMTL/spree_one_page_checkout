module OnePageCheckout
  class OrderSummaryWidget < Apotomo::Widget
    include Spree::Core::Engine.routes.url_helpers

    helper Spree::BaseHelper
    helper Spree::OrdersHelper

    # has_widgets do
    #   self << widget('one_page_checkout/order_summary/line_item', :opco_line_item)
    # end

    # responds_to_event :cart_updated, with: :redraw_adjustments, passing: :root
    # responds_to_event :line_item_removed, with: :redraw_line_items, passing: :root

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
