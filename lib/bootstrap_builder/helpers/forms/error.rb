module BootstrapBuilder
  module Helpers
    module Forms
      module Error # :nodoc:
      
        def has_error?(method_name, options = {})
          method_name && !(options[:error_disabled]) && @object.respond_to?(:errors) && !(@object.errors[method_name].empty?)
        end

        def error_message(method_name, options = {})
          content_tag(:ui, class: "text-danger") { @object.errors[method_name].collect { |msg| concat(content_tag(:li, msg)) }} if has_error?(method_name, options)
        end
      end
    end
  end
end