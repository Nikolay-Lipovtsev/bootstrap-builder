require 'test_helper'

class CollectionTest < ActionView::TestCase
  include BootstrapBuilder::Base
  
  def setup
    @user = User.new(name: "My Name", email: "my.name@email.com", password: "example")
    User.new(name: "Testov Test", email: "t.testov@email.com", password: "example").save
    User.new(name: "Ivanov Ivan", email: "i.ivanov@email.com", password: "example").save
    User.new(name: "Petrov Petr", email: "petov.p@email.com", password: "example").save
  end
  
  # Default form
  test "default form with collection" do
    expected = default_form { %{<div class="form-group"><label for="user_id">Id</label><div class="checkbox"><label><input type="checkbox" value="1" name="user[id][]" id="user_id_1" />Testov Test</label></div><div class="checkbox"><label><input type="checkbox" value="2" name="user[id][]" id="user_id_2" />Ivanov Ivan</label></div><div class="checkbox"><label><input type="checkbox" value="3" name="user[id][]" id="user_id_3" />Petrov Petr</label></div><input multiple="multiple" type="hidden" name="user[id][]" id="user_id" /></div>} }
    assert_equal expected, bootstrap_form_for(@user) { |f| f.collection_check_boxes :id, User.all, :id, :name }
  end
end