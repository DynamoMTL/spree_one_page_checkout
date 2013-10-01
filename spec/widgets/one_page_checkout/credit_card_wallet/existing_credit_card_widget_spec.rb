require 'spec_helper'

def register_widget
  has_widgets do |root|
    root << widget('one_page_checkout/credit_card_wallet/existing_credit_card', :opco_existing_credit_card, user: user)
  end
end

module OnePageCheckout::CreditCardWallet
  describe ExistingCreditCardWidget do
    register_widget

    let(:user) { double('user', id: 1) }
    let(:credit_card) { double(:credit_card, display_number: 'XXXX-XXXX-XXXX-1111')}

    it "renders the :display state" do
      render_widget(:opco_existing_credit_card, :display, credit_card).tap do |rendered|
        expect(rendered).to have_selector("[data-hook=opco-existing-credit-card]")
      end
    end
  end
end
