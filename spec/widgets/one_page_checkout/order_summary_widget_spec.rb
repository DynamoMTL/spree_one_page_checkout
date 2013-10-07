require 'spec_helper'

module OnePageCheckout
  describe OrderSummaryWidget do
    class << self
      def register_widget
        let(:current_order) { double(:order).as_null_object }

        has_widgets do |root|
          root << widget('one_page_checkout/order_summary',
                         :opco_order_summary,
                         order: current_order)
        end
      end
    end

    register_widget

    let(:summary_widget) { root.find_widget(:opco_order_summary) }
    let(:rendered) { render_widget(:opco_order_summary, :display) }

    it "renders a summary of the order" do
      expect(rendered).to have_selector("[data-hook=opco-order-summary]")
    end

    context "when receiving a :shipping_method_updated event" do
      register_widget

      it "reloads the order" do
        expect(current_order).to receive(:reload)

        trigger!
      end

      it "redraws the widget" do
        expect(summary_widget).to receive(:replace) do |with, payload|
          expect(with).to eq state: :display
        end

        trigger!
      end

      def trigger!
        trigger(:shipping_method_updated, :opco_order_summary)
      end
    end

    context "when receiving a :shipping_address_updated event" do
      register_widget

      it "reloads the order" do
        expect(current_order).to receive(:reload)

        trigger!
      end

      it "redraws the widget" do
        expect(summary_widget).to receive(:replace) do |with, payload|
          expect(with).to eq state: :display
        end

        trigger!
      end

      def trigger!
        trigger(:shipping_address_updated, :opco_order_summary)
      end
    end
  end
end
