module Extensions
  module Spree
    module Address
      extend ActiveSupport::Concern

      included do
        belongs_to :user, class_name: 'Spree::User'
      end
    end
  end
end

::Spree::Address.send(:include, ::Extensions::Spree::Address)

