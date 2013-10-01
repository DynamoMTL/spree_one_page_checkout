require 'spec_helper'

def register_widget
  has_widgets do |root|
    root << widget('one_page_checkout/credit_card_wallet/new_credit_card', :opco_new_credit_card, user: user)
  end
end

describe OnePageCheckout::CreditCardWallet::NewCreditCardWidget do
  register_widget

  let(:new_credit_card_widget) { root.find_widget(:opco_new_credit_card) }
  let(:user) { double('user', id: 1) }

  it "renders the :form state" do
    render_widget(:opco_new_credit_card, :form).tap do |rendered|
      expect(rendered).to have_css('form')
    end
  end

  it "renders the :call_to_action state" do
    render_widget(:opco_new_credit_card, :call_to_action).tap do |rendered|
      expect(rendered).to have_css('a', text: 'Add Credit Card')
    end
  end

  context "when receiving a :reveal_form event" do
    register_widget

    it "renders the :form state" do
      expect(new_credit_card_widget).to receive(:replace) do |state_or_view, args|
        expect(state_or_view).to eq(state: :form)
      end

      trigger(:reveal_form, :opco_new_credit_card)
    end
  end

  context "when receiving a :create_credit_card event" do
    register_widget

    let!(:new_credit_card_widget) { root.find_widget(:opco_new_credit_card) }

    let(:credit_card_form) { double(:credit_card_form) }
    let(:create_credit_card_service) { double(:create_credit_card_service)}
    let(:new_credit_card) { double(:new_credit_card) }

    before do
      CreateCreditCardFactory.stub(:build).and_return(create_credit_card_service)
      Forms::CreditCardForm.stub(:new).and_return(credit_card_form)

      new_credit_card_widget.stub(:replace)
      new_credit_card_widget.stub(:trigger)
      create_credit_card_service.stub(:call)
    end

    context "with a valid credit_card submission" do
      register_widget

      before do
        create_credit_card_service.stub(:call).and_return(new_credit_card)
      end

      it "triggers a :credit_card_created event" do
        expect(new_credit_card_widget).to receive(:trigger).with(:credit_card_created, credit_card: new_credit_card)

        trigger!
      end
    end

    context "with an invalid credit_card submission" do
      register_widget

      before do
        create_credit_card_service.stub(:call).and_return(false)
      end

      it "redraws the :form state" do
        expect(new_credit_card_widget).to receive(:replace) do |state_or_view, args|
          expect(state_or_view).to eq(state: :form)
        end

        trigger!
      end
    end

    def trigger!
      trigger(:create_credit_card, :opco_new_credit_card, { credit_card: double })
    end
  end
end
