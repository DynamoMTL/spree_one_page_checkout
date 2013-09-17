require 'spec_helper'

module Spree
  describe CheckoutController do
    include Spree::Core::TestingSupport::ControllerRequests

    let(:current_order) { create(:order_with_totals) }
    let(:current_user) { create(:user) }

    before do
      controller.stub(:spree_current_user).and_return(current_user)
      controller.stub(:current_order).and_return(current_order)
    end

    describe 'GET #edit' do
      context "without a 'state' param" do
        let(:params) { Hash.new }

        it "doesn't redirect" do
          spree_get :edit, params

          expect(response).to_not be_redirect
        end
      end

      context "with a 'state' param" do
        let(:params) { Hash[state: 'address'] }

        it "redirects to /checkout" do
          spree_get :edit, params

          expect(response).to redirect_to spree.checkout_path
        end
      end
    end

    describe 'PUT #update' do
      let(:params) { Hash.new }

      it "redirects to /checkout" do
        spree_put :update, params

        expect(response).to redirect_to spree.checkout_path
      end
    end
  end
end
