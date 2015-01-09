module BootstrapBuilder
  module Helpers
    module Forms
      module HelpHelper # :nodoc:
      
        def help_block(options = {})
          content_tag :p, options[:help_block], class: "help-block" if options[:help_block]
        end
      end
    end
  end
end