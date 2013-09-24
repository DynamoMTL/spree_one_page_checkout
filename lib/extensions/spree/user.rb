module Extensions
  module Spree
    module User
      extend ActiveSupport::Concern

      included do
        has_many :addresses, class_name: 'Spree::Address'
      end
    end
  end
end

::Spree::User.send(:include, ::Extensions::Spree::User)
