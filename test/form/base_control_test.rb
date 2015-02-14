require 'test_helper'

class BaseControlTest < ActionView::TestCase
  include BootstrapBuilder::Base
  
  def setup
    setup_test_fixture
  end
  
  # Default form
  test "default form with text field" do
    expected = default_form { %{<div class="form-group"><label class="control-label" for="user_name">Name</label><input class="form-control" type="text" value="Ivan Ivanov" name="user[name]" id="user_name" /></div>} }
    assert_equal expected, bootstrap_form_for(@user) { |f| f.text_field :name }
  end
  
  test "default form with text field and with my label text" do
    expected = default_form { %{<div class="form-group"><label class="control-label" for="user_name">With my label text</label><input class="form-control" type="text" value="Ivan Ivanov" name="user[name]" id="user_name" /></div>} }
    assert_equal expected, bootstrap_form_for(@user) { |f| f.text_field :name, label: "With my label text" }
  end
  
  test "default form with text field and with invisible label" do
    expected = default_form { %{<div class="form-group"><label class="control-label sr-only" for="user_name">Name</label><input class="form-control" type="text" value="Ivan Ivanov" name="user[name]" id="user_name" /></div>} }
    assert_equal expected, bootstrap_form_for(@user) { |f| f.text_field :name, invisible_label: true }
  end
  
  test "default form with text field and withot label" do
    expected = default_form { %{<div class="form-group"><input class="form-control" type="text" value="Ivan Ivanov" name="user[name]" id="user_name" /></div>} }
    assert_equal expected, bootstrap_form_for(@user) { |f| f.text_field :name, label_disabled: true }
  end
  
  test "default form with text field and with label class" do
    expected = default_form { %{<div class="form-group"><label class="my-label-class control-label" for="user_name">Name</label><input class="form-control" type="text" value="Ivan Ivanov" name="user[name]" id="user_name" /></div>} }
    assert_equal expected, bootstrap_form_for(@user) { |f| f.text_field :name, label_class: "my-label-class" }
  end
  
  test "default form with text field and with my control class" do
    expected = default_form { %{<div class="form-group"><label class="control-label" for="user_name">Name</label><input class="my-control-class form-control" type="text" value="Ivan Ivanov" name="user[name]" id="user_name" /></div>} }
    assert_equal expected, bootstrap_form_for(@user) { |f| f.text_field :name, control_class: "my-control-class" }
  end
  
  test "default form with text field and with my form group class" do
    expected = default_form { %{<div class="form-group my-form-group-class"><label class="control-label" for="user_name">Name</label><input class="form-control" type="text" value="Ivan Ivanov" name="user[name]" id="user_name" /></div>} }
    assert_equal expected, bootstrap_form_for(@user) { |f| f.text_field :name, form_group_class: "my-form-group-class" }
  end
  
  test "default form with text field and with disabled option" do
    expected = default_form { %{<div class="form-group"><label class="control-label" for="user_name">Name</label><input class="form-control" disabled="disabled" type="text" value="Ivan Ivanov" name="user[name]" id="user_name" /></div>} }
    assert_equal expected, bootstrap_form_for(@user) { |f| f.text_field :name, disabled: true }
  end
  
  test "default form with text field and with readonly option" do
    expected = default_form { %{<div class="form-group"><label class="control-label" for="user_name">Name</label><input class="form-control" readonly="readonly" type="text" value="Ivan Ivanov" name="user[name]" id="user_name" /></div>} }
    assert_equal expected, bootstrap_form_for(@user) { |f| f.text_field :name, readonly: true }
  end
  
  test "default form with text field and with my placeholder" do
    expected = default_form { %{<div class="form-group"><label class="control-label" for="user_name">Name</label><input class="form-control" placeholder="My text" type="text" value="Ivan Ivanov" name="user[name]" id="user_name" /></div>} }
    assert_equal expected, bootstrap_form_for(@user) { |f| f.text_field :name, placeholder: "My text" }
  end
  
  test "default form with text field and with boolean placeholder" do
    expected = default_form { %{<div class="form-group"><label class="control-label" for="user_name">Name</label><input class="form-control" placeholder="Name" type="text" value="Ivan Ivanov" name="user[name]" id="user_name" /></div>} }
    assert_equal expected, bootstrap_form_for(@user) { |f| f.text_field :name, placeholder: true }
  end
  
  test "default form with text field and with size option" do
    expected = default_form { %{<div class="form-group"><label class="control-label" for="user_name">Name</label><input class="form-control input-lg" type="text" value="Ivan Ivanov" name="user[name]" id="user_name" /></div>} }
    assert_equal expected, bootstrap_form_for(@user) { |f| f.text_field :name, size: "lg" }
  end
  
  test "default form with text field and with style option" do
    expected = default_form { %{<div class="form-group has-success"><label class="control-label" for="user_name">Name</label><input class="form-control" type="text" value="Ivan Ivanov" name="user[name]" id="user_name" /></div>} }
    assert_equal expected, bootstrap_form_for(@user) { |f| f.text_field :name, style: "success" }
  end
  
  test "default form with text field and with icon option" do
    expected = default_form { %{<div class="form-group has-feedback"><label class="control-label" for="user_name">Name</label><input class="form-control" type="text" value="Ivan Ivanov" name="user[name]" id="user_name" /><span class="glyphicon glyphicon-ok form-control-feedback" aria-hidden="true"></span></div>} }
    assert_equal expected, bootstrap_form_for(@user) { |f| f.text_field :name, icon: "ok" }
  end
  
  test "default form with text field and with help option" do
    expected = default_form { %{<div class="form-group"><label class="control-label" for="user_name">Name</label><input class="form-control" type="text" value="Ivan Ivanov" name="user[name]" id="user_name" /><p class="help-block">Text for help block</p></div>} }
    assert_equal expected, bootstrap_form_for(@user) { |f| f.text_field :name, help_block: "Text for help block" }
  end
  
  test "default form with text field and with input group" do
    expected = default_form { %{<div class="form-group"><label class="control-label" for="user_name">Name</label><div class="input-group"><input class="form-control" type="text" value="Ivan Ivanov" name="user[name]" id="user_name" /><span class="input-group-addon">.com</span></div></div>} }
    assert_equal expected, bootstrap_form_for(@user) { |f| f.text_field :name, input_group: { type: :right_char, value: ".com" } }
  end
  
  test "default form with text field and with control col" do
    expected = default_form { %{<div class="form-group"><div class="row"><div class="col-md-4 col-md-offset-6"><label class="control-label" for="user_name">Name</label><input class="form-control" type="text" value="Ivan Ivanov" name="user[name]" id="user_name" /></div></div></div>} }
    assert_equal expected, bootstrap_form_for(@user) { |f| f.text_field :name, control_col: 4, offset_control_col: 6 }
  end
  
  # Horizontal form
  test "horizontal form with text field" do
    expected = horizontal_form { %{<div class="form-group"><label class="control-label col-md-2" for="user_name">Name</label><div class="col-md-10"><input class="form-control" type="text" value="Ivan Ivanov" name="user[name]" id="user_name" /></div></div>} }
    assert_equal expected, bootstrap_form_for(@user, layout: :horizontal) { |f| f.text_field :name }
  end
  
  # Inline form
  test "inline form with text field" do
    expected = inline_form { %{<div class="form-group"><label class="control-label sr-only" for="user_name">Name</label><input class="form-control" type="text" value="Ivan Ivanov" name="user[name]" id="user_name" /></div>} }
    assert_equal expected, bootstrap_form_for(@user, layout: :inline) { |f| f.text_field :name }
  end
end