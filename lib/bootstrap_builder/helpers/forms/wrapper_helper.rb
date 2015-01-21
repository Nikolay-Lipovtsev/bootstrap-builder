require 'bootstrap_builder/grid_system'

module BootstrapBuilder
  module Helpers
    module Forms
      module WrapperHelper # :nodoc:
      
        include BootstrapBuilder::GridSystem
      
        BASE_OPTIONS = [:id, :class]
      
        def form_group(label, content, options = {})
          base_form_group(label, content, options)
        end
      
        private
      
        def form_group_builder(options = {})
          return yield if options[:form_group_disabled]
          options[:class] = [options.delete(:form_group_class), "form-group"].compact.join " "
          options[:id]    = [options.delete(:form_group_id)].compact.join " "
          content_tag :div, yield, options.slice(*BASE_OPTIONS)
        end
      
        def base_form_group(label, content, options = {})
          grid_system_options               = {}
          grid_system_options[:offset_col]  = options.delete(:offset_control_col)
          grid_system_options[:col]         = options.delete(:control_col)
          grid_system_options[:grid_system] = options.delete(:grid_system)
          if options[:layout] == "horizontal" && !(options[:form_group_col_disabled])
            grid_system_options[:offset_col] ||= 2 unless label
            grid_system_options[:col] ||= 10
            content = bootstrap_col(grid_system_options) { content.html_safe }
          else
            base_form_group_with_any_grid_system_options = true if grid_system_options[:col] || grid_system_options[:offset_col]
          end
          content = form_group_builder(options) { [label, content].compact.join.html_safe }
          content = bootstrap_row_with_col(grid_system_options) { content } if base_form_group_with_any_grid_system_options
          content
        end
      end
    end
  end
end