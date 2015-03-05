module BootstrapBuilder
  module Helpers
    module Forms
      module Tags
        module Base
          class BaseParams # :nodoc:
            
            attr_reader :method_name, :layout, :template
            attr_accessor :options
            
            def initialize(method_name, layout, template, options)
              @method_name = method_name
              @layout  = layout
              @template = template
              @options = options || {}
            end
          end
        end
      end
    end
  end
end