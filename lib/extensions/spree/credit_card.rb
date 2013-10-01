module Extensions
  module Spree
    module CreditCard
      extend ActiveSupport::Concern

      included do
        belongs_to :user, class_name: 'Spree::User'

        attr_accessible :user_id
      end
    end
  end
end

::Spree::CreditCard.send(:include, ::Extensions::Spree::CreditCard)
