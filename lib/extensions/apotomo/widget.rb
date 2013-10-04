module Extensions
  module Apotomo
    module Widget
      extend ActiveSupport::Concern

      included do
        helper ::Apotomo::WidgetWrapper
      end
    end
  end
end

::Apotomo::Widget.send(:include, ::Extensions::Apotomo::Widget)
