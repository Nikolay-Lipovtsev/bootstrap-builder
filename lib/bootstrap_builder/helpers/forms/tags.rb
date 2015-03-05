require 'bootstrap_builder/helpers/forms/tags/base'
require 'bootstrap_builder/helpers/forms/tags/base_control'

module BootstrapBuilder
  module Helpers
    module Forms
      module Tags #:nodoc:
    
        include BootstrapBuilder::Helpers::Forms::Tags::Base::BaseParams
        include BootstrapBuilder::Helpers::Forms::Tags::BaseControl::BaseControlParams
      end
    end
  end
end