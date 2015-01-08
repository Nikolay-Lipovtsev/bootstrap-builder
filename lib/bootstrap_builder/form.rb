require 'bootstrap_builder/helpers/forms'

module BootstrapBuilder
  module Form
    module Base
      
      def bootstrap_form_for(object, options = {}, &block)
        
        
        options[:html] ||= {}
        options[:html][:role] = "form"
        options[:html][:class] = ["form-#{options[:layout].to_s}", options[:html][:class]].compact.join(" ") if options[:layout]
        options[:builder] ||= BootstrapBuilder::Form::FormBuilder

        disabled(options) { form_for object, options, &block }
      end

      private

      def disabled(options = {})
        options[:disabled] ? content_tag(:fieldset, disabled: true) { yield } : yield
      end
    end
    
    class FormBuilder < ActionView::Helpers::FormBuilder
      
      include BootstrapBuilder::Helpers::Forms
      
      BASE_CONTROL_HELPERS.each do |helper|
        define_method(helper) do |method_name, *args|
          options = args.detect { |a| a.is_a?(Hash) } || {}
          options[:class] = "control"
          helper_tag = super method_name, options.slice(:class, :disabled, :placeholder, :readonly, :rows)
        end
      end
    end
  end
end