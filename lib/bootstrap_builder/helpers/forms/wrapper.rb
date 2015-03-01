require 'bootstrap_builder/grid_system'

module BootstrapBuilder
  module Helpers
    module Forms
      module Wrapper
        class WrapperBuilder # :nodoc:
          
          include BootstrapBuilder::GridSystem
          
          delegate :capture, :content_tag, :label_tag, to: :@template
          
          @@depth_wraps = 0
          
          def initialize(method, label, template, options)
            @method             = method
            @label              = label || options[:label]
            @template           = template
            @options            = options
            @label_col          = options[:label_col]
            @label_offset_col   = options[:label_offset_col]
            @control_col        = options[:control_col]
            @control_offset_col = options[:control_offset_col]
            @layout             = options[:layout]
            @label_class        = options[:label_class]
            @form_group_class   = options[:form_group_class]
            @label_col_object   = col_builder(:label)
            @control_col_object = col_builder(:control)
          end
          
          def label_builder
            unless @options[:label_disabled]
              options[:class] = "control-label #{@label_col_object.col_class}" if @layout == "horizontal"
              options[:class] = "#{options[:class]} sr-only" if @options[:invisible_label]
              options[:class] = "#{options[:class]} #{@options[:label_class]}" if @options[:label_class]
              options[:id]    = @options[:label_id] if @options[:label_id]
              if @method.nil?
                label_tag(nil, @label, options)
              else
                label(@method, @label, options)
              end
            end
          end
          
          def form_group_builder
            
            if @options[:layout] == "horizontal" && !(@options[:form_group_col_disabled])
              @grid_system_options[:offset_col]  ||= 2 unless @label
              @grid_system_options[:col]         ||= 10
              @content = bootstrap_col(@grid_system_options) { @content.html_safe }
            end
            
            @content = [@label, @content].compact.join.html_safe
            @content = bootstrap_row_with_col(@grid_system_options) { @content } if [:col, :offset_col].any? { |k| @grid_system_options.key?(k) }
            return @content if @options[:form_group_disabled] || @@depth_wraps > 0
            @options[:class] = ["form-group", @options[:form_group_class]].compact.join(" ")
            @options[:id]    = @options[:form_group_id] if @options[:form_group_id]
            content_tag(:div, @content, @options.slice(:id, :class))
          end
          
          private
          
          def col_builder(object_type)
            col         = instance_varible_get("@#{object_type}_col")
            col         = instance_method("default_horizontal_#{object_type}_col") if @layout == "horizontal" && !(col)
            offset_col  = instance_varible_get("@#{object_type}_offset_col")
            Column.new(col, offset_col, @template)
          end
          
          def default_horizontal_label_col
            2
          end
          
          def default_horizontal_control_col
            10
          end
        end
      end
      
      FORM_GROUP_OPTIONS = [:form_group_disabled, :label_disabled, :layout, :row_disabled]
      
      def form_group(label = nil, content_or_options = nil, options = {}, label_is_tag = false, &block)
        options = @options.slice(*FORM_GROUP_OPTIONS).merge(options)
        WrapperBuilder.new(@template, label, content_or_options, options, label_is_tag, &block).form_group_builder
      end
    end
  end
end