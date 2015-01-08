module BootstrapBuilder
  module Alert
    
    def bootstrap_alert(type_or_options = default_alert_name, options = {})
      options, type_or_options = type_or_options, default_alert_name if type_or_options.is_a? Hash
      options.stringify_keys!
      
      options["class"] = ["alert alert-#{type_or_options.to_s}", options["class"]].compact.join " "
      options["role"] = "alert"
      if options.delete("dismissible")
        options["class"].concat(" alert-dismissible")
        content = dismissible
      end
      content = [content, yield].compact.join.html_safe 
      content_tag :div, content, options
    end
    
    private
    
    def dismissible
      span = content_tag :span, "&times;".html_safe, "arial-hidden" => "true"
      content_tag :button, span, "type" => "button", "class" => "close", "data-dismiss" => "alert", "aria-label" => "Close"
    end
    
    def default_alert_name
      "danger"
    end
  end
end