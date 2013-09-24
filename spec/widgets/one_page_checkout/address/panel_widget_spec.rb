require 'spec_helper'

def register_widget
  has_widgets do |root|
    root << widget('one_page_checkout/address/panel', :opco_address_book)
  end
end

describe OnePageCheckout::Address::PanelWidget do
  register_widget

  let!(:address_book_widget) { root.find_widget(:opco_address_book) }

  let(:current_user) { create(:user) }
  let(:rendered) { render_widget(:opco_address_book, :display, current_user) }

  it "renders the address-book panel" do
    expect(rendered).to have_selector("[data-hook=opco-shipping-address-book]")
  end

  it "renders the new-address form" do
    expect(rendered).to have_selector('[data-hook=opco-new-shipping-address]')
  end

  context "with addresses in the current user's address-book" do
    register_widget

    before do
      create_list(:address, 2, user: current_user)
    end

    it "renders an address-book entry for each address" do
      expect(rendered).to have_selector('[data-hook=opco-existing-shipping-address]', count: 2)
    end
  end

  context "when receiving an :address_created event" do
    register_widget

    it "renders the :display state" do
      address_book_widget = root.find_widget(:opco_address_book)

      expect(address_book_widget).to receive(:replace) do |state_or_view, args|
        expect(state_or_view).to eq(state: :display)
      end

      trigger(:address_created, :opco_address_book, { user: double })
    end
  end
end
