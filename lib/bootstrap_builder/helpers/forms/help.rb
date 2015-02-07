module BootstrapBuilder
  module Helpers
    module Forms
      module Help # :nodoc:
      
        def help_block(options = {})
          content_tag :p, options.delete(:help_block), class: "help-block" if options[:help_block]
        end
      end
    end
  end
end