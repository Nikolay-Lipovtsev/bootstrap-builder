require 'bootstrap_builder/grid_system'

module BootstrapBuilder
  module Helpers
    module Forms
      module WrapperHelper # :nodoc:
      
        include BootstrapBuilder::GridSystem
      
        BASE_OPTIONS = [:id, :class]
      
        def form_group(label, content, options = {})
          @form_group_disabled = true
          if options[:layout] == "horizontal"
            horizontal_form_group(label, content, options) { yield }
          else 
            base_form_group(label, content, options) { yield }
          end
        end
      
        private
      
        def form_group_builder(options = {})
          return yield if options.delete(:form_group_disabled)
          options[:class] = ["form-group", options.delete(:form_group_class)].compact.join " "
          
          content_tag :div, yield, options.slice(*BASE_OPTIONS)
        end
      
        def base_form_group(label, content, options = {})
          form_group_builder(options) { [label, content].compact.join.html_safe }
        end
      
        def horizontal_form_group(label, content, options = {})
          grid_system_options               = {}
          grid_system_options[:offset_col]  = options.delete(:offset_control_col) || 2 unless label
          grid_system_options[:col]         = options.delete(:control_col) || 10
          grid_system_options[:grid_system] = options.delete(:grid_system)
          content                           = bootstrap_col(grid_system_options) { content }
          form_group_builder(options) { [label, content].compact.join.html_safe }
        end
      end
    end
  end
end