require 'test_helper'

class CheckBoxAndRadioTest < ActionView::TestCase
  include BootstrapBuilder::Base
  
  def setup
    @user = User.new(email: 'example@example.com', password: 'example')
  end
end