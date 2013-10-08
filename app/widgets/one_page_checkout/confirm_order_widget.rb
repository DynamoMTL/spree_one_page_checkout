module OnePageCheckout
  class ConfirmOrderWidget < Apotomo::Widget
    responds_to_event :confirm_order

    def initialize(parent, id, options = {})
      super(parent, id, options)

      @order = options.fetch(:order)
    end

    def display
      render
    end

    def confirm_order
      # TODO Extract to service
      5.times { order.next }

      order_completion_path = spree.order_path(order)

      render text: "location.href = '#{order_completion_path}';"
    end

    private

    attr_reader :order

    def redirect_to_completed_order_page
    end

    def spree
      Spree::Core::Engine.routes.url_helpers
    end
  end
end
