require 'spec_helper'

module Spree
  describe CheckoutController do
    include Spree::Core::TestingSupport::ControllerRequests

    let(:spree_current_user) { create(:user) }

    before do
      controller.stub(:spree_current_user).and_return(spree_current_user)
    end

    describe 'PUT #update' do
      let(:order) { create(:order_with_totals) }
      let(:params) { Hash.new }

      before do
        controller.stub(:current_order).and_return(order)
      end

      it "redirects to /checkout" do
        spree_put :update, params

        expect(response).to redirect_to spree.checkout_path
      end
    end
  end
end
