require 'bootstrap_builder/alert'
require 'bootstrap_builder/button'
require 'bootstrap_builder/form'
require 'bootstrap_builder/glyphicon'
require 'bootstrap_builder/grid_system'

module BootstrapBuilder
  module Base #:nodoc:
    
    include BootstrapBuilder::Alert
    include BootstrapBuilder::Button
    include BootstrapBuilder::Form
    include BootstrapBuilder::Glyphicon
    include BootstrapBuilder::GridSystem  
    
    def add_html_class(class_val, new_class, reverse = false)
      if class_val.blank? || new_class.blank?
        "#{new_class}#{class_val}"
      else
        reverse ? "#{new_class} #{class_val}" : "#{class_val} #{new_class}"
      end
    end
  end
end