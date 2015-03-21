require 'bootstrap_builder/glyphicon'
require 'bootstrap_builder/grid_system'

module BootstrapBuilder
  module Helpers
    module WrapperHelper #:nodoc:
    
      class BaseWrapper
        
        BASE_OPTIONS = [:control_class, :control_col, :label_disabled, :invisible_label, :form_group_disabled, 
                            :grid_system, :label_class, :label_col, :layout, :offset_control_col, :offset_label_col, 
                            :row_disabled]
        
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
        
        def control_options
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
        
        def render(&block)
          raise ArgumentError, "Missing block" unless block_given?
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
        
        def initialize(helper, object, method, template, options = {})
          super(options[:label], helper, object, method, template, options)
          set_base_control_options
        end
        
        def render(content)
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