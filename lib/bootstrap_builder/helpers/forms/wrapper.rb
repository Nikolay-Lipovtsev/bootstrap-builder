require 'bootstrap_builder/grid_system'

module BootstrapBuilder
  module Helpers
    module Forms
      module Wrapper
        class WrapperBuilder # :nodoc:
          
          @@depth_wraps = 0
          
          include BootstrapBuilder::GridSystem
          
          delegate :capture, :content_tag, :label_tag, to: :@template
          
          def initialize(template, label, content_or_options, options, label_is_tag, &block)
            @template                           = template
            @label                              = label
            @grid_system_options                = {}
            @grid_system_options[:col]          = @options[:control_col]        if @options[:control_col]
            @grid_system_options[:grid_system]  = @options[:grid_system]        if @options[:grid_system]
            @grid_system_options[:offset_col]   = @options[:offset_control_col] if @options[:offset_control_col]
            @grid_system_options[:row_disabled] = @options[:row_disabled]       if @options[:row_disabled]
            
            if block_given?
              @options      = content_or_options || {}
              @@depth_wraps += 1
              @content      = capture(&block)
              @@depth_wraps -= 1
            else
              @options      = options || {}
              @content      = content_or_options
            end
            
            unless label_is_tag
              @options[:label_class] = ["control-label", @options[:label_class]].compact.join(" ")
              @label = label_tag(nil, @label, class: @options[:label_class])
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