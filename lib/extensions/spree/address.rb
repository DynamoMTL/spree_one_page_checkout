module Extensions
  module Spree
    module Address
      extend ActiveSupport::Concern

      included do
        belongs_to :user, class_name: 'Spree::User'

        attr_accessible :user_id
      end
    end
  end
end

::Spree::Address.send(:include, ::Extensions::Spree::Address)

