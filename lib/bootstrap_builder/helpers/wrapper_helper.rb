require 'bootstrap_builder/glyphicon'

module BootstrapBuilder
  module Helpers
    module WrapperHelper #:nodoc:
    
      class BaseWrapper
        
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
          @options[:layout] == "horizontal"
        end
        
        def has_control_col_option?
          @options[:control_col] || @options[:offset_control_col]
        end
        
        def has_label_col_option?
          @options[:label_col] || @options[:offset_label_col]
        end
        
        def set_base_control_options
          @options[:class]    = @options.delete(:control_class)  if @options[:control_class]
          @options[:disabled] = "disabled"                       if @options[:disabled]
          @options[:readonly] = "readonly"                       if @options[:readonly]
        end
      end
      
      class FormGroupWrapper < BaseWrapper
        
        @@depth_wraps = 0
        
        def initialize(label_text, helper, object, method, template, options = {})
          super(helper, object, method, template, options)
          
          @label_text = label_text
        end
        
        def render(&block)
          content
        end
        
        private
        
        def parent?
          @@depth_wraps == 0
        end
        
        def wrap_in_row?
          !(horizontal?) && has_control_col_option?
        end
      end
      
      class BaseControlWrapper < FormGroupWrapper
        
        include BootstrapBuilder::Glyphicon
        
        def initialize(label_text, helper, object, method, template, options = {})
          super(nil, helper, object, method, template, options)
          set_base_control_options
        end
        
        def render
          content = "#{content}#{icon_block}".html_safe
        end
        
        private
        
        def icon_block
          bootstrap_glyphicon(@options[:icon], class: "form-control-feedback") if @options[:icon]
        end
      end
    end
  end
end