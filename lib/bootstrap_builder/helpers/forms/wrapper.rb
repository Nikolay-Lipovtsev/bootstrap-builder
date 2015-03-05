require 'bootstrap_builder/grid_system'

module BootstrapBuilder
  module Helpers
    module Forms
      module Wrapper
        class WrapperBuilder # :nodoc:
          
          include BootstrapBuilder::GridSystem
          
          delegate :capture, :content_tag, :label_tag, to: :@template
          
          @@depth_wraps = 0
          
          def initialize(helper, method, label, template, options)
            @helper   = helper
            @method   = method
            @label    = label || options[:label]
            @template = template
            @options  = options
          end
          
          def render(&block)
            if horizontal?
              @options[:label_col]          ||= 2
              @options[:control_col]        ||= 10
              @options[:control_offset_col] ||= 2 if no_label?
              @options[:label_col_object]   = Column.new(@options[:label_col], @options[:label_offset_col], @template)
              @options[:control_col_object] = Column.new(@options[:control_col], @options[:control_offset_col], @template)
              @options[:label_class]        = "control-label #{@options[:label_col_object].col_class} #{@options[:label_class]}".strip
            else
              @options[:control_col_object] = Column.new(@options[:col], @options[:offset_col], @template)
            end
            
            label         = label_builder
            @@depth_wraps =+ 1
            content       = "#{label}#{@options[:control_col_object].render(yield)}".html_safe
            @@depth_wraps =- 1
            
            if wrapperable?
              content = Row.new(@template).render(content) if any_col_option? && !(horizontal?)
            else
              return content
            end
            
            options[:class] = "form-group"
            options[:class] << @options[:form_group_class] if @options[:form_group_class]
            options[:id]    = @options[:form_group_id] if @options[:form_group_id]
            content_tag(:div, content, options)
          end
          
          private
          
          def label_builder(label_classes)
            unless no_label?
              options[:class] = @options[:invisible_label] ? "sr-only #{options[:class]}" : "#{label_classes}"
              options[:id]    = @options[:label_id] if @options[:label_id]
              @method ? label(@method, @label, options) : label_tag(nil, @label, options)
            end
          end
          
          def help_block
            content_tag(:p, @options[:help_block], class: "help-block" if @options[:help_block])
          end
          
          def has_error?(method_name, options = {})
            method_name && @options[:error_disabled].nil? && @object.respond_to?(:errors) && @object.errors[method_name].any?
          end

          def error_message(method_name, options = {})
            content_tag(:ui, class: "text-danger") { @object.errors[method_name].collect { |msg| concat(content_tag(:li, msg)) }} if has_error?
          end
          
          def horizontal?
            @options[:layout] == "horizontal"
          end
          
          def wrapperable?
            @@depth_wraps == 0 && !(@options[:form_group_disabled])
          end
          
          def any_col_option?
            @options[:col].any? || @options[:offset_col].any? || @options[:label_disabled]
          end
          
          def no_label?
            (@method.nil? && @label.nil?) || [:btn].include?(helper)
          end
        end
      end
      
      def form_group(method, label, control, @template, options = {}, &block)
        options = @options.slice(*FORM_GROUP_OPTIONS).merge(options)
        WrapperBuilder.new(method, label, control, @template, options).render(&block)
      end
    end
  end
end