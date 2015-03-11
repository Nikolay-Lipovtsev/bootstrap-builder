require 'bootstrap_builder/grid_system'

module BootstrapBuilder
  module Helpers
    module Forms
      module Wrapper
        class WrapperBuilder # :nodoc:
          
          include BootstrapBuilder::GridSystem
          
          attr_reader :options
          
          delegate :capture, :content_tag, :label_tag, to: :@template
          
          @@depth_wraps = 0
          
          def initialize(object, helper, method, label_text, template, form_object, control_form_group, options)
            @object             = object
            @helper             = helper
            @method             = method
            @label_text         = label_text || options[:label]
            @template           = template
            @form_object        = form_object
            @control_form_group = control_form_group
            @options            = options || {}
          end
          
          def render(content = nil, &block)
            if horizontal?
              if parent?
                @options[:label_col]          ||= 2
                @options[:control_col]        ||= 10 if @helper
                @options[:offset_control_col] ||= 2 unless label?
              else
                @options[:label_disabled] = true
              end
              @options[:label_col_object] = Column.new(@options[:label_col], @options[:offset_label_col], @template)
              @options[:label_class]      = "control-label #{@options[:label_col_object].col_class} #{@options[:label_class]}".strip
            end
            
            label_tag = label_builder
            @options[:control_col_object] = Column.new(@options[:control_col], @options[:offset_control_col], @template)
            
            @@depth_wraps += 1
            content = capture(&block) if block_given?
            @@depth_wraps -= 1
            
            content = if horizontal?
              "#{label_tag}#{@options[:control_col_object].render(content.to_s << help_block.to_s << error_message.to_s)}".html_safe
            else
              label_tag = Column.new(12, nil, @template).render(label_tag) unless @control_form_group
              @options[:control_col_object].render("#{label_tag}#{content}#{help_block}#{error_message}".html_safe)
            end
            
            if wrapperable?
              content = Row.new(@template).render(content) if rowable?
              options = {}
              options[:class] = "form-group"
              options[:class] << " #{@options[:form_group_class]}"  if @options[:form_group_class]
              options[:class] << " has-feedback"                    if @options[:icon]
              options[:class] << " form-group-#{options[:size]}"    if @options[:size] && horizontal?
              options[:class] << " has-#{options[:style]}"          if @options[:style]
              options[:id]    = @options[:form_group_id]            if @options[:form_group_id]
              content_tag(:div, content, options)
            else
              content
            end
          end
          
          private
          
          def label_builder
            if label?
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
            parent? && !(@options[:form_group_disabled])
          end
          
          def rowable?
            @options[:layout] != "horizontal" && (!(@control_form_group) || @options[:control_col] || @options[:offset_control_col])
          end
          
          def label?
            @helper != :btn && !(@options[:label_disabled]) && (@method || @label_text)
          end
          
          def parent?
            @@depth_wraps == 0
          end
        end
      end
      
      FORM_GROUP_OPTIONS = [:label_col, :control_col, :offset_control_col, :layout]
      
      def form_group(label_text = nil, options = {}, &block)
        options = @options.slice(*FORM_GROUP_OPTIONS).merge(options)
        WrapperBuilder.new(@object, nil, nil, label_text, @template, self, false, options).render(&block)
      end
      
      def control_form_group(label_text = nil, options = {}, method = nil, helper = nil, &block)
        options = @options.slice(*FORM_GROUP_OPTIONS).merge(options)
        WrapperBuilder.new(@object, helper, method, label_text, @template, self, true, options).render(&block)
      end
    end
  end
end