require 'spec_helper'

# def register_widget
#   has_widgets do |root|
#     root << widget('one_page_checkout/address_book/panel',
#                    :opco_address_book,
#                    address_repository: address_repository,
#                    user: current_user,
#                    order: current_order,
#                   )
#   end
# end
# 
module OnePageCheckout::AddressBook
  describe PanelWidget do
    class << self
      def register_widget
        let(:address_repository) { double(:address_repository) }
        let(:current_user) { double(:user, addresses: []) }
        let(:current_order) { double(:order) }

        has_widgets do |root|
          root << widget('one_page_checkout/address_book/panel',
                         :opco_address_book,
                         address_repository: address_repository,
                         user: current_user,
                         order: current_order)
        end
      end
    end

    register_widget

    let(:address_book_widget) { root.find_widget(:opco_address_book) }
    let(:rendered) { render_widget(:opco_address_book, :display) }

    it "renders the address-book panel" do
      expect(rendered).to have_selector("[data-hook=opco-address-book]")
    end

    it "renders the new-address form" do
      expect(rendered).to have_selector('[data-hook=opco-new-address]')
    end

    context "with addresses in the current user's address-book" do
      register_widget

      let(:address1) { double(:address1) }
      let(:address2) { double(:address2) }
      let(:addresses) {[ address1, address2 ]}

      before do
        current_user.stub(:addresses).and_return(addresses)
      end

      it "renders an address-book entry for each address" do
        expect(rendered).to have_selector('[data-hook=opco-existing-address]', count: 2)
      end

      context "when a currently selected address is present" do
        register_widget

        let(:rendered) { render_widget(:opco_address_book, :display, selected_address) }
        let(:selected_address) { double(:selected_address) }

        before do
          selected_address.stub(:==).with(address1).and_return(true)
          selected_address.stub(:==).with(address2).and_return(false)
        end

        it "applies a CSS class to the corresponding address-book entry" do
          expect(rendered).to have_selector('[data-hook=opco-address-book] > li.selected', count: 1)
        end
      end
    end

    context "when receiving an :address_created event" do
      register_widget

      let(:address_book_widget) { root.find_widget(:opco_address_book) }
      let(:new_address) { double(:new_address) }

      it "renders the :display state" do
        expect(address_book_widget).to receive(:replace) do |state_or_view, args|
          expect(state_or_view).to eq(state: :display)
        end

        trigger!
      end

      def trigger!
        trigger(:address_created, :opco_address_book, address: new_address)
      end
    end
  end
end
