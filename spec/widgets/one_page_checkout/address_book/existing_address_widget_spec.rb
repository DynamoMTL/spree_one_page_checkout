require 'spec_helper'

def register_widget
  has_widgets do |root|
    root << widget('one_page_checkout/address_book/existing_address', :opco_existing_address, user: user)
  end
end

module OnePageCheckout::AddressBook
  describe ExistingAddressWidget do
    register_widget

    let(:user) { double('user', id: 1) }

    it "renders the :display state" do
      render_widget(:opco_existing_address, :display).tap do |rendered|
        expect(rendered).to have_selector("[data-hook=opco-existing-address]")
      end
    end
  end
end
