require 'test_helper'

class BaseControlTest < ActionView::TestCase
  include BootstrapBuilder::Base
  
  def setup
    setup_test_fixture
  end
  
  test "default form and text field" do
    expected = default_form { %{<div class="form-group"><label class="control-label" for="user_name">Name</label><input class="form-control" type="text" name="user[name]" id="user_name"></div>} }
    assert_equal expected, bootstrap_form_for(@user) { |f| f.text_field :name }
  end
  
  test "horizontal form with" do
    expected = horizontal_form { %{<div class="form-group"><label class="control-label col-md-2" for="user_name">Name</label><div class="col-md-10"><input class="form-control" type="text" name="user[name]" id="user_name" /></div></div>} }
    assert_equal expected, bootstrap_form_for(@user, layout: :horizontal) { |f| f.text_field :name }
  end
  
  test "form with my html options with" do
    expected = inline_form { %{<div class="form-group"><label class="control-label" for="user_name">Name</label><input class="form-control" type="text" name="user[name]" id="user_name"></div>} }
    assert_equal expected, bootstrap_form_for(@user, html: { id: "foo", class: "bar" }) { |f| nil }
  end
end