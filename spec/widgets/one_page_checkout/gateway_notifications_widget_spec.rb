require 'spec_helper'

module OnePageCheckout
  describe GatewayNotificationsWidget do
    class << self
      def register_widget
        has_widgets do |root|
          root << widget('one_page_checkout/gateway_notifications',
                         :opco_gateway_notifications)
        end
      end
    end

    register_widget

    let(:notifications_widget) { root.find_widget(:opco_gateway_notifications) }
    let(:rendered) { render_widget(:opco_gateway_notifications, :display, notifications: notifications) }

    let(:notifications) { [] }

    it "renders the address-book panel" do
      expect(rendered).to have_selector("[data-hook=opco-gateway-notifications]")
    end

    context "with notifications to display" do
      register_widget

      let(:notification1) { double(:notification1) }
      let(:notification2) { double(:notification2) }
      let(:notifications) { [notification1, notification2] }

      it "renders an entry for each notification" do
        expect(rendered).to have_selector('[data-hook=opco-gateway-notifications] li', count: 2)
      end
    end

    context "when receiving a :gateway_error_raised event" do
      register_widget

      let(:gateway_error) { double(:gateway_error, message: double) }

      it "renders the :display state" do
        expect(notifications_widget).to receive(:replace) do |state_or_view, args|
          expect(state_or_view).to eq(state: :display)
        end

        trigger!
      end

      def trigger!
        trigger(:gateway_error_raised, :opco_gateway_notifications, gateway_error: gateway_error)
      end
    end
  end
end
