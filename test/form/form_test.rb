require 'test_helper'

class FormTest < ActionView::TestCase
  include BootstrapBuilder::Base
  
  def setup
    setup_test_fixture
  end
  
  test "default form" do
    expected = default_form
    assert_equal expected, bootstrap_form_for(@user) { |f| nil }
  end
  
  test "horizontal form" do
    expected = horizontal_form
    assert_equal expected, bootstrap_form_for(@user, layout: :horizontal) { |f| nil }
  end
  
  test "inline form" do
    expected = inline_form
    assert_equal expected, bootstrap_form_for(@user, layout: :inline) { |f| nil }
  end
end