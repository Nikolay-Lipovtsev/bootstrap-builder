require 'bootstrap_builder/grid_system'

module BootstrapBuilder
  module Helpers
    module Forms
      module WrapperHelper # :nodoc:
      
        include BootstrapBuilder::GridSystem
      
        BASE_OPTIONS = ["id", "form_group_class"]
      
        def form_group(label, content, options = {})
          if options["layout"] == :horizontal
            horizontal_form_group(options) { yield }
          else 
            base_form_group(options) { yield }
          end
        end
      
        private
      
        def form_group_builder(options = {})
          return yield if options.delete "form_group_disabled"
          options["class"] = ["form-group", options.delete("form_group_class")].compact.join " "
          content_tag :div, yield, options.slice(*BASE_OPTIONS)
        end
      
        def base_form_group(label, content, options = {})
          form_group_builder(options) { [label, content].compact.join.html_safe }
        end
      
        def horizontal_form_group(label, content, options = {})
          options["offset_col"] = options.delete("offset_control_col") || 2 unless label
          options["col"]        = options.delete("control_col") || 10
          content               = bootstrap_col(options) { content }
          form_group_builder(options) { [label, content].compact.join.html_safe }
        end
      end
    end
  end
end