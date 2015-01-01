require 'bootstrap_builder/grid_system'

module BootstrapBuilder
  module Helpers
    module WrapperHelper
      
      include BootstrapBuilder::GridSystem
      
      BASE_OPTIONS = ["id", "class", "form_group_class"]
      
      def form_group(options = {})
        return yield if options.delete "form_group_disabled"
        options["class"] = ["form-group", options.delete("form_group_class")].compact.join " "
        content_tag :div, yield, options.slice(*BASE_OPTIONS)
      end
      
      def horizontal_group(label, content, options = {})
        content = bootstrap_col(options) { content }
        form_group(options) { [label, content].compact.join.html_safe }
      end
      
      def horizontal_group_without_label(content, options = {})
        options["offset_col"] ||= 2
        horizontal_group nil, content, options
      end
    end
  end
end