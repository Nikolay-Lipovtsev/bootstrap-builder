module BootstrapBuilder
  module Helpers
    module Forms
      module FormHelper # :nodoc:
      
        def bootstrap_form_for(object, options = {}, &block)
          options[:html] ||= {}
          options[:html][:role] = "form"
          options[:html][:class] = ["form-#{options[:layout].to_s}", options[:html][:class]].compact.join(" ") if options[:layout]
          options[:builder] ||= BootstrapFormBuilder::Helpers::FormBuilder
  
          disabled(options) { form_for object, options, &block }
        end

        private

        def disabled(options = {})
          options[:disabled] ? content_tag(:fieldset, disabled: true) { yield } : yield
        end
      end
    end
  end
end