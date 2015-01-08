require 'test_helper'

class FormTest < ActionView::TestCase
  include BootstrapBuilder::Form::Base
  
  test "base controls" do
    @user = User.new(email: 'example@example.com', password: 'example')
    expected = %{<div class="alert alert-danger" role="alert">Test</div>}
    assert_equal expected, bootstrap_form_for(@user) { |f| f.email_field :email }
  end
end