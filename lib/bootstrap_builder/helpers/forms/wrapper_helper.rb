require 'bootstrap_builder/grid_system'

module BootstrapBuilder
  module Helpers
    module Forms
      module WrapperHelper # :nodoc:
      
        include BootstrapBuilder::GridSystem
      
        BASE_OPTIONS = [:id, :class]
        
        def form_group(content_or_options = nil, options = {}, &block)
          form_group_with_label nil, content_or_options, &block
        end
        
        def form_group_with_label(label = nil, content_or_options = nil, options = {}, &block)
          @options.merge! form_group_disabled: true, row_disabled: true, label_disabled: true
          options, content_or_options = (content_or_options || {}), capture(&block) if block_given?
          content_or_options = bootstrap_row { content_or_options } unless options[:row_disabled]
          @options.merge! form_group_disabled: false, row_disabled: false, invisible_label: false
          form_group_wrapper label, content_or_options
        end
        
        def form_group_wrapper(label, content_or_options = nil, options = {}, &block)
          options, content_or_options = content_or_options, yield if block_given?
          options ||= {}
          grid_system_options                 = {}
          grid_system_options[:offset_col]    = options.delete(:offset_control_col)
          grid_system_options[:col]           = options.delete(:control_col)
          grid_system_options[:grid_system]   = options.delete(:grid_system)
          grid_system_options[:row_disabled]  = options.delete(:row_disabled)
          if options[:layout] == "horizontal" && !(options[:form_group_col_disabled])
            grid_system_options[:offset_col] ||= 2 unless label
            grid_system_options[:col] ||= 10
            content_or_options = bootstrap_col(grid_system_options) { content_or_options.html_safe }
          else
            form_group_with_any_grid_system_options = true if grid_system_options[:col] || grid_system_options[:offset_col]
          end
          content_or_options = [label, content_or_options].compact.join.html_safe
          content_or_options = bootstrap_row_with_col(grid_system_options) { content_or_options } if form_group_with_any_grid_system_options
          form_group_builder content_or_options, options
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