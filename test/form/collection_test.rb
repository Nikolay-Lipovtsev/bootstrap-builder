require 'test_helper'

class CollectionTest < ActionView::TestCase
  include BootstrapBuilder::Base
  
  def setup
    setup_test_fixture
  end
  
  # Default form
  test "default form with collection" do
    expected = default_form { %{<div class="form-group"><label class="control-label" for="user_name">Name</label><input class="form-control" type="text" value="Ivan Ivanov" name="user[name]" id="user_name" /></div>} }
    assert_equal expected, bootstrap_form_for(@user) { |f| f.collection_check_boxes :id, User.all, :id, :name }
  end
end