require 'bootstrap_builder/helpers/forms'

module BootstrapBuilder
  module Form
    
    def bootstrap_form_for(object, options = {}, &block)
      options.symbolize_keys!
      
      options[:layout] = options[:layout].to_s if options[:layout]
      options[:html]          ||= {}
      options[:html][:role]   = "form"
      classes                 = options[:html][:class]
      options[:html][:class]  = "form-#{options[:layout]}" if options[:layout]
      options[:html][:class]  = "#{options[:html][:class]} #{classes}" if classes
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
        base_options(options)
        classes         = "form-control"
        classes         << " input-#{options[:size]}" if options[:size] && horizontal?
        classes         << " #{options[:class]}"      if options[:class]
        options[:class] = classes
        control         = super(method, options.slice(:class, :disabled, :id, :placeholder, :readonly, :rows))
        control         = "#{control}#{icon_block(options[:icon])}".html_safe
        control_form_group(nil, options, method, helper) { control }
      end
    end
    
    CHECKBOX_AND_RADIO_HELPERS.each do |helper|
      define_method(helper) do |method, *args|
        helper_name = helper.gsub(/_|button/, "")
        options = args.detect { |a| a.is_a?(Hash) } || {}
        base_options(options)
        options[:checked]     = "checked" if options[:checked]
        # ??????????????????????????????????????????????????????????????????????
        control               = super(method, *args.map { |a| a.is_a?(Hash) ? options.slice(:class, :disabled, :id, :multiple) : a })
        control               = "#{control}#{options.delete(:label_text)}".html_safe
        label_options         = {}
        label_options[:class] = "#{helper_name}-inline" if options[:inline]
        control               = label_tag(nil, control, label_options)
        if options[:inline]
          options[:label_disabled] = true
        else
          block_classes = helper_name
          block_classes << " #{options.delete(:disabled)}" if options[:disabled]
          control = content_tag(:div, control, class: block_classes)
        end
        if options[:collection]
          control
        else
          options[:form_group_disabled] = true unless horizontal?
          control_form_group(nil, options, method, helper) { control }
        end
      end
    end
    
    COLLECTION_HELPERS.each do |helper|
      define_method(helper) do |method, collection, value_method, text_method, *args|
        options = args.detect { |a| a.is_a?(Hash) } || {}
        base_options(options)
        control                       = String.new
        control_options               = options
        control_options[:multiple]    ||= true if helper == "collection_check_boxes"
        control_options[:collection]  = true
        collection.each do |object|
          control_options[:checked]     = true if (control_options[:checked] && object.send(value_method) && control_options[:checked].to_s == object.send(value_method).to_s) || control_options[:checked] == true
          control_options[:label_text]  = text_method.respond_to?(:call) ? text_method.call(object) : object.send(text_method)
          tag_value                     = value_method ? object.send(value_method) : "1"
          if helper == "collection_check_boxes"
            control << check_box(method, control_options, tag_value, nil)
          else 
            control << radio_button(method, tag_value, control_options)
          end
          control_options.delete(:checked) if control_options[:checked] == true
        end
        control << hidden_field(method, multiple: true) if helper == "collection_check_boxes"
        control_form_group(nil, options, method, helper) { control.html_safe }
      end
    end
    
    def select(method, choices = nil, select_options = {}, options = {}, &block)
      base_options(options)
      #base_control_options method, options
      control           = super method, choices, select_options, options.slice(:class, :disabled, :placeholder, :readonly, :rows), &block
      control_form_group(nil, options, method, :select) { control }
    end
    
    DATE_SELECT_HELPERS.each do |helper|
      define_method(helper) do |method, options = {}, html_options = {}|
        base_options(options)
        #base_control_options method, options
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
    
    def base_options(options)
      options ||= {}
      options.symbolize_keys!
      
      BASE_FORM_OPTIONS.each{ |name| options[name] ||= @options[name] if @options[name] }
      
      options[:class]     = options.delete(:control_class)  if options[:control_class]
      options[:disabled]  = "disabled"                      if options[:disabled]
      options[:readonly]  = "readonly"                      if options[:readonly]
    end
    
    def default_horizontal_label_col
      2
    end
    
    def horizontal?
      @options[:layout] == "horizontal"
    end
    
    def button_builder(options)
      base_options(options)
      options[:class] = options[:control_class] if options[:control_class]
      options         = options.slice(:active, :class, :col, :style, :size, :disabled)
    end
  end
end