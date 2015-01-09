module BootstrapBuilder
  module Glyphicon
    
    def bootstrap_glyphicon(name, options = {})
      options.symbolize_keys!
      
      options[:class] = ["glyphicon glyphicon-#{name.to_s.downcase.dasherize}", options[:class]].compact.join " "
      options["aria-hidden"] = "true"
      content_tag :span, nil, options
    end
  end
end