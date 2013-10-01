require 'spec_helper'

def register_widget
  has_widgets do |root|
    root << widget('one_page_checkout/credit_card_wallet/panel',
                   :opco_credit_card_wallet,
                   user: current_user, order: current_order)
  end
end

describe OnePageCheckout::CreditCardWallet::PanelWidget do
  register_widget

  let!(:credit_card_wallet_widget) { root.find_widget(:opco_credit_card_wallet) }

  let(:current_user) { create(:user) }
  let(:current_order) { double(:order) }

  let(:rendered) { render_widget(:opco_credit_card_wallet, :display) }

  it "renders the credit-card wallet panel" do
    expect(rendered).to have_selector("[data-hook=opco-credit-card-wallet]")
  end

  it "renders the new-credit-card form" do
    expect(rendered).to have_selector('[data-hook=opco-new-credit-card]')
  end

  context "with credit-cards in the current user's address-book" do
    register_widget

    before do
      create_list(:credit_card, 2, user: current_user)
    end

    it "renders an wallet entry for each credit-card" do
      expect(rendered).to have_selector('[data-hook=opco-existing-credit-card]', count: 2)
    end
  end

  context "when receiving an :credit_card_created event" do
    register_widget

    let(:credit_card_wallet_widget) { root.find_widget(:opco_credit_card_wallet) }
    let(:new_credit_card) { double(:new_credit_card) }

    it "renders the :display state" do
      expect(credit_card_wallet_widget).to receive(:replace) do |state_or_view, args|
        expect(state_or_view).to eq(state: :display)
      end

      trigger!
    end

    def trigger!
      trigger(:credit_card_created, :opco_credit_card_wallet, new_credit_card: new_credit_card)
    end
  end
end
