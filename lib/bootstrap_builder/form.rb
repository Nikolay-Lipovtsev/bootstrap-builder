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
        grid_system_class     = grid_system_class((options[:label_col] || default_horizontal_label_col), options[:grid_system]) if options[:layout] == "horizontal"
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
        control         = super method_name, options.slice(:class, :disabled, :id, :placeholder, :readonly, :rows)
        control         = [control, icon, help, error].compact.join.html_safe
        label           = label method_name, options[:label], options
        form_group label, control, options
      end
    end
    
    CHECKBOX_AND_RADIO_HELPERS.each do |helper|
      helper_name = helper.gsub /_|button/, ""
      define_method(helper) do |method_name, *args|
        options = args.detect { |a| a.is_a?(Hash) } || {}
        base_options method_name, options
        checkbox_and_radio_options options
        help              = help_block options
        error             = error_message method_name, options
        form_group_label  = label method_name, options[:form_group_label], options if options[:form_group_label]
        options[:class]   = options[:control_class]
        control           = super method_name, *args.map { |a| a.is_a?(Hash) ? options.slice(:class, :disabled, :id, :multiple) : a }
        control           = [control, options[:label]].join.html_safe
        options[:class]   = options[:label_class]
        options[:class]   = [options[:label_class], "#{helper_name}-inline"].compact.join(" ") if options[:inline]
        control           = label_tag nil, control, options.slice(:class)
        control           = checkbox_and_radio_block helper_name, control, options
        control           = [control, help, error].join.html_safe
        options[:form_group_disabled] = true unless options[:layout] == "horizontal"
        form_group form_group_label, control, options
      end
    end
    
    COLLECTION_HELPERS.each do |helper|
      define_method(helper) do |method_name, collection, value_method, text_method, *args|
        options = args.detect { |a| a.is_a?(Hash) } || {}
        base_options method_name, options
        help                          = help_block options
        error                         = error_message method_name, options
        form_group_label              = label method_name, options.delete(:form_group_label), options if options[:form_group_label]
        control                       = ""
        checked, options[:checked]    = options[:checked], nil if options[:checked]
        options[:multiple]            = true if helper == "collection_check_boxes"
        options[:form_group_disabled], options[:form_group_col_disabled], options[:error_disabled] = true, true, true
        collection.each do |object|
          options[:checked], checked  = true, nil if (checked && object.send(value_method) && checked.to_s == object.send(value_method).to_s) || checked == true
          options[:label]             = object.send text_method
          tag_value                   = value_method ? object.send(value_method) : "1"
          helper == "collection_check_boxes" ? control << check_box(method_name, options, tag_value, nil) : control << radio_button(method_name, tag_value, options)
          options[:checked] = false
        end
        options[:form_group_disabled], options[:form_group_col_disabled], options[:error_disabled] = false, false, false
        if helper == "collection_check_boxes"
          options[:value] = ""
          control << hidden_field(method_name, options)
        end
        control = [control, help, error].join.html_safe
        form_group form_group_label, control, options
      end
    end
    
    def select(method_name, choices = nil, select_options = {}, options = {}, &block)
      base_options method_name, options
      base_control_options method_name, options
      help              = help_block options
      error             = error_message method_name, options
      control           = super method_name, choices, select_options, options.slice(:class, :disabled, :placeholder, :readonly, :rows), &block
      control           = [control, help, error].compact.join.html_safe
      label             = label method_name, options[:label], options
      form_group label, control, options
    end
    
    DATE_SELECT_HELPERS.each do |helper|
      define_method(helper) do |method_name, options = {}, html_options = {}|
        base_options method_name, options
        base_control_options method_name, options
        help                  = help_block options
        error                 = error_message method_name, options
        html_options[:class]  = [options.delete(:control_class), options.delete(:class), html_options.delete(:class), "form-control bootstrap-builder-#{helper.gsub("_", "-")}"].compact.join " "
        control               = super method_name, options, html_options.slice(:class, :disabled, :placeholder, :readonly, :rows)
        control               = [control, help, error].compact.join.html_safe
        options[:label_class] = [options[:label_class], "bootstrap-builder-#{helper.gsub("_", "-")}"].compact.join " "
        label                 = label method_name, options[:label], options
        form_group label, control, options
      end
    end
    
    private
    
    def default_horizontal_label_col
      2
    end
    
    def checkbox_and_radio_block(helper_name, control, options)
      classes = [helper_name, options.delete(:disabled)].compact.join(" ")
      return content_tag(:div, control, class: classes) unless options[:inline]
      control
    end
  end
end