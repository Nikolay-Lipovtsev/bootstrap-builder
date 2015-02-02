module BootstrapBuilder
  module Helpers
    module Forms
      module Option # :nodoc:
        
        BASE_FORM_OPTIONS = [:control_class, :control_col, :label_disabled, :invisible_label, :form_group_disabled, :grid_system, 
                            :label_class, :label_col, :layout, :offset_control_col, :offset_label_col, :row_disabled]
        
        def base_options(method_name, options)
          options ||= {}
          options.symbolize_keys!
          
          BASE_FORM_OPTIONS.each{ |name| options[name] ||= @options[name] if @options[name] }
          
          options[:class] = options[:control_class]
          options[:disabled] = "disabled" if options[:disabled]
          options[:form_group_class] = [options[:form_group_class], "has-feedback"].compact.join(" ") if options[:icon]
          options[:form_group_class] = [options[:form_group_class], "form-group-#{options[:size]}"].compact.join(" ") if options[:size] && options[:layout] == "horizontal"
          options[:form_group_class] = [options[:form_group_class], "has-#{options[:style]}"].compact.join(" ") if options[:style]
          options[:readonly] = "readonly" if options[:readonly]
          options[:style] = "has-error" if has_error?(method_name, options) && !([:btn, :control_static, :label].include?(helper))
        end
        
        def base_control_options(method_name, options)
          options[:class] = [options[:class], "form-control"].compact.join(" ")
          options[:class] = [options[:class], "input-#{options[:size]}"].compact.join(" ") if options[:size] && options[:layout] != "horizontal"
          options[:placeholder] ||= options[:label] || I18n.t("helpers.label.#{@object.class.to_s.downcase}.#{method_name.to_s}") if options[:placeholder] === true
        end
        
        def checkbox_and_radio_options(options)
          options[:checked] = "checked" if options[:checked]
        end
      end
    end
  end
end