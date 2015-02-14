require 'test_helper'

class FormGroupTest < ActionView::TestCase
  include BootstrapBuilder::Base
  
  def setup
    setup_test_fixture
  end
  
  # Default form
  test "default form with form group" do
    expected = %{<div class="form-group">}
    expected << %{<label class="control-label">Label for form group</label>}
    expected << %{<div class="row">}
    expected << %{<div class="col-md-6">}
    expected << %{<label class="control-label sr-only" for="user_name">Name</label>}
    expected << %{<input class="form-control" type="text" value="Ivan Ivanov" name="user[name]" id="user_name" />}
    expected << %{</div>}
    expected << %{<div class="col-md-4">}
    expected << %{<label class="control-label sr-only" for="user_email">Email</label>}
    expected << %{<input class="form-control" type="email" value="example@example.com" name="user[email]" id="user_email" />}
    expected << %{</div></div></div>}
    expected = default_form { expected }
    
    actual = bootstrap_form_for(@user) do |f|
      f.form_group("Label for form group") do
        "#{f.text_field(:name, control_col: 6)}#{f.email_field(:email, control_col: 4)}".html_safe
      end
    end
    assert_equal expected, actual
  end
end