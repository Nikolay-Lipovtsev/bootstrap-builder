module BootstrapBuilder
  module Helpers
    module Forms
      module ControlList #:nodoc:
    
        BASE_CONTROL_HELPERS = %w{color_field date_field datetime_field datetime_local_field email_field month_field 
                                  number_field password_field phone_field range_field search_field telephone_field 
                                  text_area text_field time_field url_field week_field}
                                  
        CHECKBOX_AND_RADIO_HELPERS = %w{check_box radio_button}
        
        COLLECTION_HELPERS = %w{collection_check_boxes collection_radio_buttons}
        
        DATE_SELECT_HELPERS = %w{date_select time_select datetime_select}
      end
    end
  end
end