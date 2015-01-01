module BootstrapBuilder
  module Helpers
    module Tags
      module BaseField # :nodoc:
        
        BASE_FIELD_HELPERS = %w{color_field date_field datetime_field datetime_local_field email_field month_field 
                                number_field password_field phone_field range_field search_field telephone_field 
                                text_area text_field time_field url_field week_field}
                                
        BASE_FIELD_HELPERS.each do |helper|
          define_method(helper) do |method_name, *args|
            options = args.detect { |a| a.is_a?(Hash) } || {}
            form_group_builder(helper, method_name, options) do
              options[:class] = ["form-control", options[:control_class], options[:size]].compact.join " "
              icon_tag = icon_block(options) || ""
              help_tag = help_block(options) || ""
              error_tag = error_message(method_name, options) || ""
              helper_tag = super method_name, options.slice(:class, :disabled, :placeholder, :readonly, :rows)
              helper_tag = col_block(helper, options) { [input_group_for_base_controls(options) { [helper_tag, icon_tag].join.html_safe }, help_tag, error_tag].join.html_safe }
              [label(method_name, options[:label], options), helper_tag].join.html_safe
            end
          end
        end
      end
    end
  end
end