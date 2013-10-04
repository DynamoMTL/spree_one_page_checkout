require 'spec_helper'

def register_widget
  has_widgets do |root|
    root << widget('one_page_checkout/address_book/new_address', :opco_new_address, user: user)
  end
end

describe OnePageCheckout::AddressBook::NewAddressWidget do
  register_widget

  let(:user) { double('user', id: 1) }

  it "renders the :form state" do
    render_widget(:opco_new_address, :form).tap do |rendered|
      expect(rendered).to have_css('form')
    end
  end

  it "renders the :call_to_action state" do
    render_widget(:opco_new_address, :call_to_action).tap do |rendered|
      expect(rendered).to have_css('a', text: 'Add Address')
    end
  end

  context "when receiving a :reveal_form event" do
    register_widget

    it "renders the :form state" do
      address_widget = root.find_widget(:opco_new_address)

      expect(address_widget).to receive(:replace) do |state_or_view, args|
        expect(state_or_view).to eq(state: :form)
      end

      trigger(:reveal_form, :opco_new_address)
    end
  end

  context "when receiving a :create_address event" do
    register_widget

    let!(:address_widget) { root.find_widget(:opco_new_address) }

    let(:address_form) { double(:address_form) }
    let(:create_address_service) { double(:create_address_service)}
    let(:new_address) { double(:new_address) }

    before do
      CreateAddressFactory.stub(:build).and_return(create_address_service)
      Forms::AddressForm.stub(:new).and_return(address_form)

      address_widget.stub(:replace)
      address_widget.stub(:trigger)
      create_address_service.stub(:call)
    end

    context "with a valid address submission" do
      register_widget

      before do
        create_address_service.stub(:call).and_return(new_address)
      end

      it "triggers a :address_created event" do
        expect(address_widget).to receive(:trigger).with(:address_created, address: new_address)

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
      trigger(:create_address, :opco_new_address, { address: double })
    end
  end
end
