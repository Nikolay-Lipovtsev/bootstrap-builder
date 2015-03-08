require 'bootstrap_builder/grid_system'

module BootstrapBuilder
  module Helpers
    module Forms
      module Wrapper
        class WrapperBuilder # :nodoc:
          
          include BootstrapBuilder::GridSystem
          
          delegate :capture, :content_tag, :label_tag, to: :@template
          
          @@depth_wraps = 0
          
          def initialize(object, helper, method, label_text, template, form_object, options)
            @object       = object
            @helper       = helper
            @method       = method
            @label_text   = label_text || options[:label]
            @template     = template
            @form_object  = form_object
            @options      = options || {}
          end
          
          def render(&block)
            if horizontal?
              @options[:label_col]          ||= 2
              @options[:control_col]        ||= 10
              @options[:offset_control_col] ||= 2 if no_label?
              @options[:label_col_object]   = Column.new(@options[:label_col], @options[:offset_label_col], @template)
              @options[:label_class]        = "control-label #{@options[:label_col_object].col_class} #{@options[:label_class]}".strip
            end
            
            label_tag = label_builder
            @options[:control_col_object] = Column.new(@options[:control_col], @options[:offset_control_col], @template)
            @@depth_wraps += 1
            capture do
            content = if horizontal?
              "#{label_tag}#{@options[:control_col_object].render(&block)}#{help_block}#{error_message}".html_safe
            else
              @options[:control_col_object].render { "#{label_tag}#{yield}#{help_block}#{error_message}".html_safe }
            end
          end
            @@depth_wraps -= 1
            
            if wrapperable?
              content = Row.new(@template).render { content } if any_col_option? && !(horizontal?)
              options = {}
              options[:class] = "form-group"
              options[:class] << @options[:form_group_class] if @options[:form_group_class]
              options[:id]    = @options[:form_group_id] if @options[:form_group_id]
              content_tag(:div, content, options)
            else
              return content
            end
          end
          
          private
          
          def label_builder
            unless no_label?
              options = {}
              options[:class] = "sr-only" if @options[:invisible_label]
              options[:class] = "#{options[:class]} #{@options[:label_class]}".strip if @options[:label_class]
              options[:id]    = @options[:label_id] if @options[:label_id]
              @method ? @form_object.label(@method, @label_text, options) : label_tag(nil, @label_text, options)
            end
          end
          
          def help_block
            content_tag(:p, @options[:help_block], class: "help-block") if @options[:help_block]
          end
          
          def has_error?
            @method && @options[:error_disabled].nil? && @object.respond_to?(:errors) && @object.errors[@method].any?
          end

          def error_message
            content_tag(:ui, class: "text-danger") { @object.errors[@method].collect { |msg| concat(content_tag(:li, msg)) }} if has_error?
          end
          
          def horizontal?
            @options[:layout] == "horizontal"
          end
          
          def wrapperable?
            @@depth_wraps == 0 && !(@options[:form_group_disabled])
          end
          
          def any_col_option?
            @options[:control_col] || @options[:offset_control_col]
          end
          
          def no_label?
            (@method.nil? && @label_text.nil?) || @helper == :btn || @options[:label_disabled]
          end
        end
      end
      
      FORM_GROUP_OPTIONS = [:label_col, :control_col, :offset_control_col]
      
      def form_group(label_text, options = {}, method = nil, helper = nil, &block)
        options = @options.slice(*FORM_GROUP_OPTIONS).merge(options)
        WrapperBuilder.new(@object, helper, method, label_text, @template, self, options).render(&block)
      end
    end
  end
end