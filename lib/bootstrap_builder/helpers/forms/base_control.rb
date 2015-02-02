require 'bootstrap_builder/helpers/forms/control_list_helper'
require 'bootstrap_builder/helpers/forms/option_helper'
require 'bootstrap_builder/helpers/forms/wrapper_helper'

module BootstrapBuilder
  module Helpers
    module Forms
      module BaseControl # :nodoc:
        
        include BootstrapBuilder::Helpers::Forms::ControlList
        include BootstrapBuilder::Helpers::Forms::Option
        include BootstrapBuilder::Helpers::Forms::Wrapper
      end
    end
  end
end