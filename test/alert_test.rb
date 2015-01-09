require 'test_helper'

class AlertTest < ActionView::TestCase
  include BootstrapBuilder::Base
  
  test "alert with default type" do
    expected = %{<div class="alert alert-danger" role="alert">Test</div>}
    assert_equal expected, bootstrap_alert { "Test" }
  end
  
  test "alert with my type" do
    expected = %{<div class="alert alert-success" role="alert">Test</div>}
    assert_equal expected, bootstrap_alert("success") { "Test" }
  end
  
  test "alert with dismissible" do
    expected = %{<div class="alert alert-danger alert-dismissible" role="alert"><button type="button" class="close" data-dismiss="alert" aria-label="Close"><span arial-hidden="true">&times;</span></button>Test</div>}
    assert_equal expected, bootstrap_alert(dismissible: true) { "Test" }
  end
  
  test "alert with my html options" do
    expected = %{<div id="foo" class="alert alert-danger bar" role="alert">Test</div>}
    assert_equal expected, bootstrap_alert(id: "foo", class: "bar") { "Test" }
  end
end