require 'spec_helper'

module OnePageCheckout::ShippingAddressBook
  describe PanelWidget do
    class << self
      def register_widget
        let(:address_repository) { double(:address_repository) }
        let(:current_user) { double(:user, addresses: []) }
        let(:current_order) { double(:order) }

        has_widgets do |root|
          root << widget('one_page_checkout/shipping_address_book/panel',
                         :opco_shipping_address_book,
                         address_repository: address_repository,
                         user: current_user,
                         order: current_order)
        end
      end
    end

    register_widget

    let(:panel_widget) { root.find_widget(:opco_shipping_address_book) }
    let(:rendered) { render_widget(:opco_shipping_address_book, :display, current_address) }

    let(:current_address) { double(:current_address) }

    # FIXME Duplicated specs between this and its superclass
    it "renders the address-book panel" do
      expect(rendered).to have_selector("[data-hook=opco-address-book]")
    end

    # FIXME Duplicated specs between this and its superclass
    it "renders the new-address form" do
      expect(rendered).to have_selector('[data-hook=opco-new-address]')
    end

    context "when receiving a :shipping_address_updated event" do
      register_widget

      let(:address) { double(:address) }
      let(:address_book_widget) { root.find_widget(:opco_address_book) }

      before do
        panel_widget.stub(:replace)
      end

      it "redraws the widget" do
        expect(panel_widget).to receive(:replace) do |with, payload|
          expect(with).to eq state: :display
          expect(payload).to eq address
        end

        trigger!
      end

      def trigger!
        trigger(:shipping_address_updated, :opco_shipping_address_book, address: address)
      end
    end

    context "when receiving a :billing_address_updated event" do
      register_widget

      it "redraws the widget" do
        expect(panel_widget).to receive(:replace) do |with, payload|
          expect(with).to eq state: :display
        end

        trigger!
      end

      def trigger!
        trigger(:billing_address_updated, :opco_shipping_address_book, address: double)
      end
    end
  end
end
