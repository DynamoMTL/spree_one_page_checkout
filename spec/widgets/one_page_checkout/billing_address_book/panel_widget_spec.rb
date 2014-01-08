require 'spec_helper'

module OnePageCheckout::BillingAddressBook
  describe PanelWidget do
    class << self
      def register_widget
        let(:address_repository) { double(:address_repository) }
        let(:current_address) { double(:current_address) }
        let(:current_order) { double(:order) }
        let(:current_user) { double(:user, addresses: []) }

        has_widgets do |root|
          root << widget('one_page_checkout/billing_address_book/panel',
                         :opco_billing_address_book,
                         address_repository: address_repository,
                         current_address: current_address,
                         order: current_order,
                         user: current_user)
        end
      end
    end

    register_widget

    let(:panel_widget) { root.find_widget(:opco_billing_address_book) }
    let(:rendered) { render_widget(:opco_billing_address_book, :display, current_address) }

    # FIXME Duplicated specs between this and its superclass
    it "renders the address-book panel" do
      expect(rendered).to have_selector("[data-hook=opco-address-book]")
    end

    # FIXME Duplicated specs between this and its superclass
    it "renders the new-address form" do
      expect(rendered).to have_selector('[data-hook=opco-new-address]')
    end

    context "when receiving a :billing_address_updated event" do
      register_widget

      let(:address) { double(:address) }
      let(:address_book_widget) { root.find_widget(:opco_address_book) }

      before do
        panel_widget.stub(:replace)
      end

      it "redraws the widget" do
        expect(panel_widget).to receive(:replace) do |with, payload|
          expect(with).to eq state: :display
          expect(payload).to be_nil
        end

        trigger!
      end

      def trigger!
        trigger(:billing_address_updated, :opco_billing_address_book, address: address)
      end
    end

    context "when receiving a :shipping_address_updated event" do
      register_widget

      before do
        current_order.stub(:reload).and_return(current_order)
        current_order.stub(:bill_address).and_return(double)
      end

      it "redraws the widget" do
        expect(panel_widget).to receive(:replace) do |with, payload|
          expect(with).to eq state: :display
        end

        trigger!
      end

      def trigger!
        trigger(:shipping_address_updated, :opco_billing_address_book, address: double)
      end
    end
  end
end
