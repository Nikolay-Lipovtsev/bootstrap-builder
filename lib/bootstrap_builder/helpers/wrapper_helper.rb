require 'bootstrap_builder/glyphicon'
require 'bootstrap_builder/grid_system'

module BootstrapBuilder
  module Helpers
    module WrapperHelper #:nodoc:
    
      class BaseWrapper
        
        BASE_OPTIONS = [:control_class, :control_col, :control_col_object, :control_id, :error_disabled, 
                        :label_disabled, :invisible_label, :form_group_class, :form_group_disabled, :form_group_id, 
                        :grid_system, :help_block, :icon, :label, :label_class, :label_col, :label_col_object,
                        :label_id, :label_text, :layout, :offset_control_col, :offset_label_col, :row_disabled, :style]
                        
        MAIN_HELPERS = %w{color_field date_field datetime_field datetime_local_field email_field month_field 
                                  number_field password_field phone_field range_field search_field telephone_field 
                                  text_area text_field time_field url_field week_field}
                
        CHECKBOX_AND_RADIO_HELPERS = %w{check_box radio_button}

        COLLECTION_HELPERS = %w{collection_check_boxes collection_radio_buttons}

        DATE_SELECT_HELPERS = %w{date_select time_select datetime_select}
        
        delegate :capture, :content_tag, :label_tag, to: :@template
        
        def initialize(helper, object, method, template, options = {})
          @helper   = helper
          @object   = object
          @method   = method
          @template = template
          @options  = options || {}
        end
        
        protected
        
        def horizontal?
          @options[:layout] == :horizontal
        end
        
        def has_control_col_option?
          @options[:control_col] || @options[:offset_control_col]
        end
        
        def has_label_col_option?
          @options[:label_col] || @options[:offset_label_col]
        end
        
        def set_main_helper_options
          @options[:class]    = @options.delete(:control_class)  if @options[:control_class]
          @options[:disabled] = "disabled"                       if @options[:disabled]
          @options[:readonly] = "readonly"                       if @options[:readonly]
        end
        
        def helper_options
          @options.excetp(*BASE_OPTIONS)
        end
      end
      
      class FormGroupWrapper < BaseWrapper
        
        include BootstrapBuilder::GridSystem
        
        @@depth_wraps = 0
        
        def initialize(label_text, helper, object, method, template, options = {})
          super(helper, object, method, template, options)
          @label_text = label_text
        end
        
        def render(content = nil, &block)
          raise ArgumentError, "Missing block" unless block_given? && content
          @@depth_wraps += 1
          content = capture(&block) if block_given?
          @@depth_wraps -= 1
        end
        
        def main_control_builder
          initialize_control_col_object
        end
        
        def horizontal_control_builder
          if parent?
            @options[:control_col]        ||= 10
            @options[:offset_control_col] ||= 2 if offsetting?
          end
          
          initialize_control_col_object
        end
        
        def initialize_control_col_object
          @options[:control_col_object] = Column.new(@options[:control_col], @options[:offset_control_col], @options[:grid_system], @template)
        end
        
        def main_label_builder
          options         = {}
          options[:class] = "sr-only"                                             if @options[:invisible_label]
          options[:class] = "#{options[:class]} #{@options[:label_class]}".strip  if @options[:label_class]
          options[:id]    = @options[:label_id]                                   if @options[:label_id]
          @method ? @form_object.label(@method, @label_text, options) : label_tag(nil, @label_text, options)
        end
        
        def horizontal_label_builder
          @options[:label_col]        = @options[:label_col] || 2
          @options[:offset_label_col] = @options[:offset_label_col]
          @options[:label_col_object] = Column.new(@options[:label_col], @options[:offset_label_col], @options[:grid_system], @template)
          @options[:label_class]      = "control-label #{@options[:label_col_object].html_class} #{@options[:label_class]}".strip
          
          main_label_builder
        end
        
        private
        
        def parent?
          @@depth_wraps == 0
        end
        
        def wrap_in_row?
          !(horizontal?) && has_control_col_option?
        end
        
        def help_block
          content_tag(:p, @options[:help_block], class: "help-block") if @options[:help_block]
        end
        
        def has_error?
          error_helpers = MAIN_HELPERS + CHECKBOX_AND_RADIO_HELPERS + COLLECTION_HELPERS
          error_helpers.include?(@helper) && @method && @options[:error_disabled].nil? && @object.respond_to?(:errors) && @object.errors[@method].any?
        end

        def error_message
          if has_error?
            @options[:style] = "has-error"
            content_tag(:ui, class: "text-danger") { @object.errors[@method].collect { |msg| concat(content_tag(:li, msg)) }}
          end
        end
        
        def label?
          !(@options[:label_disabled]) && (@method || @label_text) && (!horizontal? || parent?)
        end
        
        def wrap?
          parent? && !(@options[:form_group_disabled])
        end
      end
      
      class MainWrapper < FormGroupWrapper
        
        include BootstrapBuilder::Glyphicon
        
        def initialize(helper, object, method, template, options = {})
          super(options[:label], helper, object, method, template, options)
          set_base_control_options
        end
        
        def render(content)
          content = "#{content}#{help_block}#{error_message}"
        end
        
        private
        
        def icon_block
          bootstrap_glyphicon(@options[:icon], class: "form-control-feedback") if @options[:icon]
        end
      end
    end
  end
end