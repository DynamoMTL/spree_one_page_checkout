require 'spec_helper'

def register_widget
  has_widgets do |root|
    root << widget('one_page_checkout/credit_card_wallet/panel',
                   :opco_credit_card_wallet,
                   current_credit_card: current_credit_card,
                   order: current_order,
                   user: current_user)
  end
end

describe OnePageCheckout::CreditCardWallet::PanelWidget do
  register_widget

  let!(:credit_card_wallet_widget) { root.find_widget(:opco_credit_card_wallet) }

  let(:current_credit_card) { double(:credit_card) }
  let(:current_order) { double(:order) }
  let(:current_user) { create(:user) }

  let(:rendered) { render_widget(:opco_credit_card_wallet, :display) }

  it "renders the credit-card wallet panel" do
    expect(rendered).to have_selector("[data-hook=opco-credit-card-wallet]")
  end

  it "renders the new-credit-card form" do
    expect(rendered).to have_selector('[data-hook=opco-new-credit-card]')
  end

  context "with credit-cards in the current user's address-book" do
    register_widget

    let(:credit_card1) { double(:credit_card1, display_number: '1111') }
    let(:credit_card2) { double(:credit_card2, display_number: '2222') }
    let(:credit_cards) {[ credit_card1, credit_card2 ]}

    before do
      current_user.stub(:credit_cards).and_return(credit_cards)
    end

    it "renders an wallet entry for each credit-card" do
      expect(rendered).to have_selector('[data-hook=opco-existing-credit-card]', count: 2)
    end

    context "with a currently selected credit-card" do
      register_widget

      let(:rendered) { render_widget(:opco_credit_card_wallet, :display) }

      before do
        current_credit_card.stub(:eql?).with(credit_card1).and_return(true)
        current_credit_card.stub(:eql?).with(credit_card2).and_return(false)
      end

      it "applies a CSS class to the corresponding wallet entry" do
        expect(rendered).to have_selector('[data-hook=opco-credit-card-wallet] .selected', count: 1)
      end
    end
  end

  context "when receiving a :payment_created event" do
    register_widget

    let(:credit_card_wallet_widget) { root.find_widget(:opco_credit_card_wallet) }
    let(:credit_card) { double(:credit_card) }
    let(:payment) { double(:payment, source: credit_card) }

    it "renders the :display state" do
      expect(credit_card_wallet_widget).to receive(:replace) do |state_or_view, args|
        expect(state_or_view).to eq(state: :display)
      end

      trigger!
    end

    def trigger!
      trigger(:payment_created, :opco_credit_card_wallet, payment: payment)
    end
  end
end
