module BootstrapBuilder
  module Helpers
    module Forms
      module OptionHelper # :nodoc:
      
        def base_options(options)
          options ||= {}
        
          BASE_FORM_OPTIONS.each{ |name| options[name] ||= @options[name] if @options[name] }
        
          options[:checked] = "checked" if options[:checked]
          options[:disabled] = "disabled" if options[:disabled]
          options[:form_group_class] = ["has-feedback", options[:form_group_class]].compact.join(" ") if options[:icon]
          options[:form_group_size] = "form-group-#{options.delete(:size)}" if options[:size] && options[:layout] == :horizontal
          options[:placeholder] ||= options[:label] || I18n.t("helpers.label.#{@object.class.to_s.downcase}.#{method_name.to_s}") if (options[:placeholder] || options[:invisible_label] || options[:layout] == :inline) && [*BASE_CONTROL_HELPERS].include?(helper)
          options[:readonly] = "readonly" if options[:readonly]
          options[:size] = "input-#{options.delete(:size)}" if options[:size] && helper != "btn"
          options[:style] = "has-#{options.delete(:style)}" if options[:style] && helper != "btn"
          options[:style] = "has-error" if has_error?(method_name, options) && !(["btn", "control_static", "label"].include?(helper))
        end
      end
    end
  end
end