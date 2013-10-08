require 'spec_helper'

module OnePageCheckout
  describe OrderSummaryWidget do
    class << self
      def register_widget
        let(:current_order) { double(:order) }

        has_widgets do |root|
          root << widget('one_page_checkout/confirm_order',
                         :opco_confirm_order,
                         order: current_order)
        end
      end
    end

    register_widget

    let(:confirm_widget) { root.find_widget(:opco_confirm_order) }
    let(:rendered) { render_widget(:opco_confirm_order, :display) }

    it "renders a button to confirm the order" do
      expect(rendered).to have_selector("[data-hook=opco-confirm-order]", text: /Confirm My Order/)
    end

    context "when receiving a :confirm_order event" do
      register_widget

      let(:completed_order_path) { double(:completed_order_path, to_s: 'completed_order_path') }
      let(:url_helpers) { double(:url_helpers) }

      before do
        Spree::Core::Engine.routes.stub(:url_helpers).and_return(url_helpers)

        url_helpers.stub(:order_path).with(current_order).and_return(completed_order_path)
        current_order.stub(:next)
        current_order.stub(:complete?)
      end

      it "completes the order" do
        expect(current_order).to receive(:next).exactly(5).times

        trigger!
      end

      context "with a successfully completed order" do
        register_widget

        before do
          current_order.stub(:complete?).and_return(true)
        end

        it "redirects to the order-completion page" do
          expect(url_helpers).to receive(:order_path).with(current_order)

          expect(confirm_widget).to receive(:render) do |with, payload|
            expect(with[:text]).to match /#{completed_order_path}/
          end

          trigger!
        end
      end

      def trigger!
        trigger(:confirm_order, :opco_confirm_order)
      end
    end
  end
end
