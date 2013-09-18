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

  context "when receiving a :create_address event" do
    register_widget

    let!(:address_widget) { root.find_widget(:opco_address) }

    let(:create_address_factory) { double(:create_address_factory) }
    let(:create_address_service) { double(:create_address_service) }

    before do
      address_widget.stub(:create_address_factory).and_return(create_address_factory)
      address_widget.stub(:replace)

      create_address_factory.stub(:build).and_return(create_address_service)
      create_address_service.stub(:call)
    end

    it "persists the new address" do
      trigger(:create_address, :opco_address)

      expect(create_address_factory).to have_received(:build)
      expect(create_address_service).to have_received(:call)
    end

    it "renders the :display state" do
      trigger(:create_address, :opco_address)

      expect(address_widget).to have_received(:replace) do |state_or_view, args|
        expect(state_or_view).to eq(state: :display)
      end
    end
  end
end
