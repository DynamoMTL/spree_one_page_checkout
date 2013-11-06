module OnePageCheckout
  class GatewayNotificationsWidget < Apotomo::Widget
    responds_to_event :gateway_error_raised, with: :redraw, passing: :root

    def initialize(parent, id, options = {})
      super

      @notifications = []
    end

    def display(options = {})
      notifications.append options.fetch(:notifications, [])

      render
    end

    def redraw(event)
      notifications.append event.data.fetch(:gateway_error).message

      replace state: :display
    end

    private

    attr_reader :notifications
    helper_method :notifications
  end
end
