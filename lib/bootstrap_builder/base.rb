require 'bootstrap_builder/alert'
require 'bootstrap_builder/form'
require 'bootstrap_builder/glyphicon'
require 'bootstrap_builder/grid_system'

module BootstrapBuilder
  module Base #:nodoc:
    
    include BootstrapBuilder::Alert
    include BootstrapBuilder::Form
    include BootstrapBuilder::Glyphicon
    include BootstrapBuilder::GridSystem    
  end
end