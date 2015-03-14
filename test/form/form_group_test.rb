require 'test_helper'

class FormGroupTest < ActionView::TestCase
  include BootstrapBuilder::Base
  
  def setup
    setup_test_fixture
  end
  
  # Default form
  test "default form with form group" do
    expected = %{<div class="form-group">
                  <div class="row">
                    <div class="col-md-12"><label>Label for form group</label></div>
                    <div class="col-md-6">
                      <label for="user_name">Name</label>
                      <input class="form-control" type="text" value="Ivan Ivanov" name="user[name]" id="user_name" />
                    </div>
                    <div class="col-md-4">
                      <label for="user_email">Email</label>
                      <input class="form-control" type="email" value="example@example.com" name="user[email]" id="user_email" />
                    </div>
                  </div>
                </div>}
    expected = default_form { expected.gsub(/\n/, "").gsub(/> +</, "><") }
    
    actual = bootstrap_form_for(@user) do |f|
      f.form_group("Label for form group") do
        "#{f.text_field(:name, control_col: 6)}#{f.email_field(:email, control_col: 4)}".html_safe
      end
    end
    assert_equal expected, actual
  end
end