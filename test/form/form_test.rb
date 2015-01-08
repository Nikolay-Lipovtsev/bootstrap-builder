require 'test_helper'

class FormTest < ActionView::TestCase
  include BootstrapBuilder
  
  def setup
    @user = User.new(email: 'example@example.com', password: 'example')
  end
  
  test "base controls" do
    expected = %{<div class="alert alert-danger" role="alert">Test</div>}
    assert_equal expected, bootstrap_form_for(@user) { |f| f.email_field :email }
  end
end