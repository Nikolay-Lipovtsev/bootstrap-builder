require 'bootstrap_builder/glyphicon'

module BootstrapBuilder
  module Helpers
    module Forms
      module Icon # :nodoc:
        
        include BootstrapBuilder::Glyphicon
        
        def icon_block(icon_option)
          bootstrap_glyphicon(icon_option, class: "form-control-feedback") if icon_option
        end
      end
    end
  end
end