module Extensions
  module Spree
    module User
      extend ActiveSupport::Concern

      included do
        has_many :addresses, class_name: 'Spree::Address'
        has_many :credit_cards, class_name: 'Spree::CreditCard'
      end
    end
  end
end

::Spree::User.send(:include, ::Extensions::Spree::User)
