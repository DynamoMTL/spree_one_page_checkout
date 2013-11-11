module OnePageCheckout
  class ConfirmOrderWidget < Apotomo::Widget
    responds_to_event :shipping_address_updated, with: :redraw, passing: :root
    responds_to_event :shipping_method_updated, with: :redraw, passing: :root
    responds_to_event :confirm_order

    def initialize(parent, id, options = {})
      super(parent, id, options)

      @order = options.fetch(:order)
    end

    def display
      render
    end

    def redraw
      replace state: :display
    end

    def confirm_order
      # TODO Extract to service
      5.times { order.next }

      redirect_to_completed_order_page if order.complete?
    end

    private

    attr_reader :order

    def redirect_to_completed_order_page
      render text: "location.href = '#{spree.order_path(order)}';"
    end

    def spree
      Spree::Core::Engine.routes.url_helpers
    end
  end
end
