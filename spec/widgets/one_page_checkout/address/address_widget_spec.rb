require 'spec_helper'

def register_widget
  has_widgets do |root|
    root << widget('one_page_checkout/address/address', :opco_address)
  end
end

describe OnePageCheckout::Address::AddressWidget do
  register_widget

  it "renders the :display state" do
    render_widget(:opco_address, :display).tap do |rendered|
      expect(rendered).to have_selector("h1")
    end
  end

  it "renders the :form state" do
    render_widget(:opco_address, :form).tap do |rendered|
      expect(rendered).to have_css('form')
    end
  end

  it "renders the :call_to_action state" do
    render_widget(:opco_address, :call_to_action).tap do |rendered|
      expect(rendered).to have_css('a', text: 'Add Address')
    end
  end

  context "when receiving a :reveal_form event" do
    register_widget

    it "renders the :form state" do
      address_widget = root.find_widget(:opco_address)

      address_widget.should_receive(:replace) do |state_or_view, args|
        expect(state_or_view).to eq(state: :form)
      end

      trigger(:reveal_form, :opco_address)
    end
  end
end
