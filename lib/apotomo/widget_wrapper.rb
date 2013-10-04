module Apotomo
  module WidgetWrapper
    def widget_div(options={}, &block)
      options.reverse_merge!(id: widget_id, tag: :div)
      tag_name = options.delete(:tag)

      content_tag(tag_name, options, &block)
    end
  end
end
