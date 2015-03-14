require 'bootstrap_builder/helpers/forms'

module BootstrapBuilder
  module Form
    
    def bootstrap_form_for(object, options = {}, &block)
      options.symbolize_keys!
      
      options[:layout] = options[:layout].to_s if options[:layout]
      options[:html]          ||= {}
      options[:html][:role]   = "form"
      options[:html][:class]  = "form-#{options[:layout]} #{options[:html][:class]}" if options[:layout]
      options[:builder]       ||= BootstrapBuilder::FormBuilder

      form_disabled(options) { form_for object, options, &block }
    end
    
    private
    
    def form_disabled(options = {})
      options[:disabled] ? content_tag(:fieldset, disabled: true) { yield } : yield
    end
  end
  
  class FormBuilder < ActionView::Helpers::FormBuilder
    
    include BootstrapBuilder::Helpers::Forms
    
    BASE_FORM_OPTIONS = [:control_class, :control_col, :label_disabled, :invisible_label, :form_group_disabled, 
                        :grid_system, :label_class, :label_col, :layout, :offset_control_col, :offset_label_col, 
                        :row_disabled]
    
    def fields_for_with_bootstrap(record_name, record_object = nil, fields_options = {}, &block)
      fields_options, record_object = record_object, nil if record_object.is_a?(Hash) && record_object.extractable_options?
      BASE_FORM_OPTIONS.each { |name| fields_options[name] ||= options[name] if options[name] }
      fields_for_without_bootstrap record_name, record_object, fields_options, &block
    end
    
    alias_method_chain :fields_for, :bootstrap
    
    delegate  :button_input_tag, :button_link_tag, :button_tag, :content_tag, :capture, :concat, :label_tag, 
              :submit_tag, to: :@template
    
    BASE_CONTROL_HELPERS.each do |helper|
      define_method(helper) do |method, *args|
        options = args.detect { |a| a.is_a?(Hash) } || {}
        base_options method, options
        base_control_options method, options
        icon            = icon_block options
        control         = super method, options.slice(:class, :disabled, :id, :placeholder, :readonly, :rows)
        control_form_group(nil, options, method, helper) { control }
      end
    end
    
    CHECKBOX_AND_RADIO_HELPERS.each do |helper|
      helper_name = helper.gsub /_|button/, ""
      define_method(helper) do |method, *args|
        options = args.detect { |a| a.is_a?(Hash) } || {}
        base_options method, options
        checkbox_and_radio_options options
        options[:class]   = options[:control_class]
        control           = super method, *args.map { |a| a.is_a?(Hash) ? options.slice(:class, :disabled, :id, :multiple) : a }
        control           = "#{control}#{options[:label_text]}".html_safe
        options[:class]   = [options[:class], "#{helper_name}-inline"].compact.join(" ") if options[:inline]
        control           = label_tag nil, control, options.slice(:class)
        control           = checkbox_and_radio_block helper_name, control, options
        options[:form_group_disabled] = true unless options[:layout] == "horizontal"
        control_form_group(nil, options, method, helper) { control }
      end
    end
    
    COLLECTION_HELPERS.each do |helper|
      define_method(helper) do |method, collection, value_method, text_method, *args|
        options = args.detect { |a| a.is_a?(Hash) } || {}
        base_options method, options
        control                       = ""
        checked, options[:checked]    = options[:checked], nil if options[:checked]
        options[:multiple]            = true if helper == "collection_check_boxes"
        options[:form_group_disabled], options[:form_group_col_disabled], options[:error_disabled] = true, true, true
        collection.each do |object|
          options[:checked], checked  = true, nil if (checked && object.send(value_method) && checked.to_s == object.send(value_method).to_s) || checked == true
          options[:label_text]        = object.send text_method
          tag_value                   = value_method ? object.send(value_method) : "1"
          helper == "collection_check_boxes" ? control << check_box(method, options, tag_value, nil) : control << radio_button(method, tag_value, options)
          options[:checked] = false
        end
        options[:form_group_disabled], options[:form_group_col_disabled], options[:error_disabled] = false, false, false
        if helper == "collection_check_boxes"
          options[:value] = ""
          control << hidden_field(method, multiple: true)
        end
        control_form_group(nil, options, method, helper) { control.html_safe }
      end
    end
    
    def select(method, choices = nil, select_options = {}, options = {}, &block)
      base_options method, options
      base_control_options method, options
      control           = super method, choices, select_options, options.slice(:class, :disabled, :placeholder, :readonly, :rows), &block
      control_form_group(nil, options, method, :select) { control }
    end
    
    DATE_SELECT_HELPERS.each do |helper|
      define_method(helper) do |method, options = {}, html_options = {}|
        base_options method, options
        base_control_options method, options
        html_options[:class]  = [options.delete(:control_class), options.delete(:class), html_options.delete(:class), "form-control bootstrap-builder-#{helper.gsub("_", "-")}"].compact.join " "
        control               = super method, options, html_options.slice(:class, :disabled, :placeholder, :readonly, :rows)
        options[:label_class] = [options[:label_class], "bootstrap-builder-#{helper.gsub("_", "-")}"].compact.join " "
        control_form_group(nil, options, method, helper) { control }
      end
    end
    
    def button(content_or_options = nil, options = {}, &block)
      content_is_options = content_or_options.is_a? Hash
      options, content_or_options = content_or_options, nil if content_is_options
      button_builder options
      content_or_options, options = options, nil if content_is_options
      control = button_tag content_or_options, options, &block
      control_form_group(nil, options, nil, :btn) { control }
    end
    
    def button_link(name = nil, options = {}, html_options = {}, &block)
      button_builder html_options
      control = button_link_tag name, options, html_options, &block
      control_form_group(nil, options, nil, :btn) { control }
    end
    
    def submit(value = nil, options = {})
      button_builder options
      control = submit_tag value, options
      control_form_group(nil, options, nil, :btn) { control }
    end
    
    def button_input(value = nil, options = {})
      button_builder options
      control = button_input_tag value, options
      control_form_group(nil, options, nil, :btn) { control }
    end
    
    private
    
    def base_options(method_name, options)
      options ||= {}
      options.symbolize_keys!
      
      BASE_FORM_OPTIONS.each{ |name| options[name] ||= @options[name] if @options[name] }
      
      options[:class]     = options.delete(:control_class)  if options[:control_class]
      options[:disabled]  = "disabled"                      if options[:disabled]
      options[:readonly]  = "readonly"                      if options[:readonly]
    end
    
    def base_control_options(method_name, options)
      classes = options[:class]
      
      options[:class].add_html_class("form-control")
      options[:class].add_html_class("input-#{options[:size]}") if options[:size] && options[:layout] != "horizontal"
      options[:class].add_html_class(classes)
      options[:placeholder] ||= options[:label] || I18n.t("helpers.label.#{@object.class.to_s.downcase}.#{method_name.to_s}") if options[:placeholder] == true
    end
    
    def checkbox_and_radio_options(options)
      options[:checked] = "checked" if options[:checked]
    end
    
    def default_horizontal_label_col
      2
    end
    
    def checkbox_and_radio_block(helper_name, control, options)
      classes = [helper_name, options.delete(:disabled)].compact.join(" ")
      return content_tag(:div, control, class: classes) unless options[:inline]
      control
    end
    
    def button_builder(options)
      base_options nil, options
      options[:class] = options[:control_class] if options[:control_class]
      options         = options.slice(:active, :class, :col, :style, :size, :disabled)
    end
  end
end