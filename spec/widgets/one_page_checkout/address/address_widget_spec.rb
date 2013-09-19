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

      address_widget.should_receive(:replace) do |state_or_view, args|
        expect(state_or_view).to eq(state: :form)
      end

      trigger(:reveal_form, :opco_address)
    end
  end

  context "when receiving a :create_address event" do
    register_widget

    let!(:address_widget) { root.find_widget(:opco_address) }

    let(:address_form) { double(:address_form) }
    let(:address_params) { double(:address_params) }

    let(:address_form_nested_data) { double(:address_form_nested_data) }

    before do
      Forms::AddressForm.stub(:new).and_return(address_form)

      address_form.stub(:validate)
      address_form.stub(:save)

      address_widget.stub(:replace)
    end

    it "validates the address submission" do
      expect(address_form).to receive(:validate).with(address_params)

      trigger!
    end

    context "with a valid address submission" do
      register_widget

      before do
        address_form.stub(:validate).and_return(true)
        address_form.stub(:save).and_yield(double, address_form_nested_data)

        Spree::Address.stub(:create!).and_return(true)
      end

      it "persists the new address" do
        expect(Spree::Address).to receive(:create!).with(address_form_nested_data)

        trigger!
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
        address_form.stub(:validate).and_return(false)
      end

      it "redraws the :form state" do
        expect(address_widget).to receive(:replace) do |state_or_view, args|
          expect(state_or_view).to eq(state: :form)
        end

        trigger!
      end
    end

    def trigger!
      trigger(:create_address, :opco_address, { address: address_params })
    end
  end
end
