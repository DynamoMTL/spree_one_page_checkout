require 'spec_helper'

def register_widget
  has_widgets do |root|
    root << widget('one_page_checkout/address_book/panel', :opco_address_book, user: current_user, order: current_order)
  end
end

describe OnePageCheckout::AddressBook::PanelWidget do
  register_widget

  let!(:address_book_widget) { root.find_widget(:opco_address_book) }

  let(:current_user) { create(:user) }
  let(:current_order) { create(:order) }

  let(:rendered) { render_widget(:opco_address_book, :display) }

  it "renders the address-book panel" do
    expect(rendered).to have_selector("[data-hook=opco-address-book]")
  end

  it "renders the new-address form" do
    expect(rendered).to have_selector('[data-hook=opco-new-address]')
  end

  context "with addresses in the current user's address-book" do
    register_widget

    before do
      create_list(:address, 2, user: current_user)
    end

    it "renders an address-book entry for each address" do
      expect(rendered).to have_selector('[data-hook=opco-existing-address]', count: 2)
    end
  end

  context "when receiving an :address_created event" do
    register_widget

    let(:address_book_widget) { root.find_widget(:opco_address_book) }
    let(:new_address) { double(:new_address) }

    before do
      current_order.stub(:update_attribute)
    end

    it "renders the :display state" do
      expect(address_book_widget).to receive(:replace) do |state_or_view, args|
        expect(state_or_view).to eq(state: :display)
      end

      trigger!
    end

    # FIXME Extract to ShippingAddress widget
    it "assigns the new address as the order's shipping address" do
      expect(current_order).to receive(:update_attribute).with(:ship_address, new_address)

      trigger!
    end

    it "triggers an :address_chosen event" do
      expect(address_book_widget).to receive(:trigger).with(:address_chosen)

      trigger!
    end

    def trigger!
      trigger(:address_created, :opco_address_book, new_address: new_address)
    end
  end
end
