module BootstrapBuilder
  module Helpers
    module Forms
      module OptionHelper # :nodoc:
        
        BASE_FORM_OPTIONS = [:control_class, :control_col, :invisible_label, :form_group_disabled, :grid_system, 
                            :label_class, :label_col, :layout, :offset_control_col, :offset_label_col]
        
        def base_options(method_name, options)
          options ||= {}
          options.symbolize_keys!
          
          BASE_FORM_OPTIONS.each{ |name| options[name] ||= @options[name] if @options[name] }
          
          options[:checked] = "checked" if options[:checked]
          options[:class] = ["form-control", options[:control_class], options[:size]].compact.join(" ")
          options[:disabled] = "disabled" if options[:disabled]
          options[:form_group_class] = ["has-feedback", options[:form_group_class]].compact.join(" ") if options[:icon]
          options[:form_group_size] = "form-group-#{options.delete(:size)}" if options[:size] && options[:layout] == "horizontal"
          options[:readonly] = "readonly" if options[:readonly]
          options[:size] = "input-#{options.delete(:size)}" if options[:size] && helper != "btn"
          options[:style] = "has-#{options.delete(:style)}" if options[:style] && helper != "btn"
          options[:style] = "has-error" if has_error?(method_name, options) && !([:btn, :control_static, :label].include?(helper))
        end
        
        def base_control_options(method_name, options)
          options[:placeholder] ||= options[:label] || I18n.t("helpers.label.#{@object.class.to_s.downcase}.#{method_name.to_s}") if (options[:placeholder] || options["invisible_label"] || options["layout"] == "inline") && [*BASE_CONTROL_HELPERS].include?(helper)
        end
      end
    end
  end
end