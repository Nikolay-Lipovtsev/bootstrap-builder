require 'bootstrap_builder/grid_system'

module BootstrapBuilder
  module Helpers
    module Forms
      module WrapperHelper # :nodoc:
      
        include BootstrapBuilder::GridSystem
      
        BASE_OPTIONS = [:id, :class]
        FORM_GROUP_OPTIONS = [:form_group_disabled, :row_disabled, :label_disabled]
        
        def form_group(label_text = nil, content_or_options = nil, options = {}, &block)
          label_class = ["control-label", options.delete(:label_class)].compact.join " "
          label_text = label_tag nil, label_text, class: label_class
          FORM_GROUP_OPTIONS.each { |name| @options[name] = true }
          options, content_or_options = (content_or_options || {}), capture(&block) if block_given?
          content_or_options = bootstrap_row { content_or_options } if @options[:layout] != "horizontal"
          FORM_GROUP_OPTIONS.each { |name| @options[name] = false }
          form_group_wrapper label_text, content_or_options, options
        end
        
        def form_group_wrapper(label, content = nil, options = {})
          options ||= {}
          grid_system_options                 = {}
          grid_system_options[:offset_col]    = options.delete(:offset_control_col)
          grid_system_options[:col]           = options.delete(:control_col)
          grid_system_options[:grid_system]   = options.delete(:grid_system)
          grid_system_options[:row_disabled]  = options.delete(:row_disabled)
          if options[:layout] == "horizontal" && !(options[:form_group_col_disabled])
            grid_system_options[:offset_col] ||= 2 unless label
            grid_system_options[:col] ||= 10
            content = bootstrap_col(grid_system_options) { content.html_safe }
          else
            form_group_with_any_grid_system_options = true if grid_system_options[:col] || grid_system_options[:offset_col]
          end
          content = [label, content].compact.join.html_safe
          content = bootstrap_row_with_col(grid_system_options) { content } if form_group_with_any_grid_system_options
          form_group_builder content, options
        end
      
        private
      
        def form_group_builder(content, options)
          return content if options[:form_group_disabled]
          options[:class] = [options.delete(:form_group_class), "form-group"].compact.join " "
          options[:id]    = options.delete(:form_group_id) if options[:form_group_id]
          content_tag :div, content, options.slice(*BASE_OPTIONS)
        end
      end
    end
  end
end