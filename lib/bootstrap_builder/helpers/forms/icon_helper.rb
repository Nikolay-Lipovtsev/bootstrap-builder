require 'bootstrap_builder/glyphicon'

module BootstrapBuilder
  module Helpers
    module Forms
      module IconHelper # :nodoc:
        
        include BootstrapBuilder::Glyphicon
        
        def icon_block(options = {})
          icon = options.delete(:icon)
          if icon
            classes = "form-control-feedback"
            bootstrap_glyphicon(icon, class: classes)
          end
        end
      end
    end
  end
end