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
      expect(rendered).to have_selector("[data-hook=opco-existing-shipping-address]")
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

      expect(address_widget).to receive(:replace) do |state_or_view, args|
        expect(state_or_view).to eq(state: :form)
      end

      trigger(:reveal_form, :opco_address)
    end
  end

  context "when receiving a :create_address event" do
    register_widget

    let!(:address_widget) { root.find_widget(:opco_address) }

    let(:address_form) { double(:address_form) }
    let(:create_address_service) { double(:create_address_service)}

    before do
      CreateAddressFactory.stub(:build).and_return(create_address_service)
      Forms::AddressForm.stub(:new).and_return(address_form)

      address_widget.stub(:replace)
      create_address_service.stub(:call)
    end

    context "with a valid address submission" do
      register_widget

      before do
        create_address_service.stub(:call).and_return(true)
      end

      it "renders the :display state" do
        expect(address_widget).to receive(:replace) do |state_or_view, args|
          expect(state_or_view).to eq(state: :display)
        end

        trigger!
      end
    end

    context "with an invalid address submission" do
      register_widget

      before do
        create_address_service.stub(:call).and_return(false)
      end

      it "redraws the :form state" do
        expect(address_widget).to receive(:replace) do |state_or_view, args|
          expect(state_or_view).to eq(state: :form)
        end

        trigger!
      end
    end

    def trigger!
      trigger(:create_address, :opco_address, { address: double })
    end
  end
end
