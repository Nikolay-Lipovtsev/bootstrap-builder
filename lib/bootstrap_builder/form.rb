require 'bootstrap_builder/helpers/forms'

module BootstrapBuilder
  module Form
          
    def bootstrap_form_for(object, options = {}, &block)
      options.symbolize_keys!
      
      options[:layout] = options[:layout].to_s if options[:layout]
      options[:html] ||= {}
      options[:html][:role] = "form"
      options[:html][:class] = ["form-#{options[:layout]}", options[:html][:class]].compact.join(" ") if options[:layout]
      options[:builder] ||= BootstrapBuilder::FormBuilder

      form_disabled(options) { form_for object, options, &block }
    end
    
    private
    
    def form_disabled(options = {})
      options[:disabled] ? content_tag(:fieldset, disabled: true) { yield } : yield
    end
  end
  
  class FormBuilder < ActionView::Helpers::FormBuilder
    
    include BootstrapBuilder::Helpers::Forms
    
    BASE_FORM_OPTIONS = [:control_class, :control_col, :invisible_label, :form_group_disabled, :grid_system, 
                        :label_class, :label_col, :layout, :offset_control_col, :offset_label_col]
    
    def fields_for_with_bootstrap(record_name, record_object = nil, fields_options = {}, &block)
      fields_options, record_object = record_object, nil if record_object.is_a?(Hash) && record_object.extractable_options?
      BASE_FORM_OPTIONS.each { |name| fields_options[name] ||= options[name] if options[name] }
      fields_for_without_bootstrap record_name, record_object, fields_options, &block
    end
    
    alias_method_chain :fields_for, :bootstrap
    
    delegate  :button_input_tag, :button_link_tag, :button_tag, :content_tag, :capture, :concat, :label_tag, 
              :submit_tag, to: :@template
    
    def label(method_name, content_or_options = nil, options = {}, &block)
      content_is_options = content_or_options.is_a? Hash
      options, content_or_options = content_or_options, nil if content_is_options
      unless options[:label_disabled]
        grid_system_class   = grid_system_class((options[:label_col] || default_horizontal_label_col), options[:grid_system]) if options[:layout] == "horizontal"
        options[:label_class] = [options[:label_class], "control-label"].compact.join(" ")
        options[:label_class] = [options[:label_class], "#{grid_system_class}"].compact.join(" ") if options[:layout] == "horizontal"
        options[:label_class] = [options[:label_class], "sr-only"].compact.join(" ") if options[:invisible_label] || options[:layout] == "inline"
        options[:class]       = options.delete(:label_class)
        options[:id]          = options.delete(:label_id)
        options               = options.slice(:id, :class)
        content_or_options, options = options, nil if content_is_options
        super method_name, content_or_options, options, &block
      end
    end
    
    BASE_CONTROL_HELPERS.each do |helper|
      define_method(helper) do |method_name, *args|
        options = args.detect { |a| a.is_a?(Hash) } || {}
        base_options method_name, options
        base_control_options method_name, options
        help            = help_block options
        error           = error_message method_name, options
        icon            = icon_block options
        options[:class] = [options[:control_class], "form-control", options[:size]].compact.join(" ")
        content         = super method_name, options.slice(:class, :disabled, :placeholder, :readonly, :rows)
        content         = [content, icon, help, error].compact.join.html_safe
        label           = label method_name, options[:label], options
        form_group label, content, options
      end
    end
    
    private
    
    def default_horizontal_label_col
      2
    end
  end
end