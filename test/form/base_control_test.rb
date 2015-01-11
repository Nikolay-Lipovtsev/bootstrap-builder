require 'test_helper'

class BaseControlTest < ActionView::TestCase
  include BootstrapBuilder::Base
  
  def setup
    @user = User.new(email: 'example@example.com', password: 'example')
  end
  
  test "default form" do
    expected = %{<form role="form" class="new_user" id="new_user" action="/users" accept-charset="UTF-8" method="post"><input name="utf8" type="hidden" value="&#x2713;" /></form>}
    assert_equal expected, bootstrap_form_for(@user) { |f| nil }
  end
  
  test "horizontal form" do
    expected = %{<form role="form" class="form-horizontal" id="new_user" action="/users" accept-charset="UTF-8" method="post"><input name="utf8" type="hidden" value="&#x2713;" /></form>}
    assert_equal expected, bootstrap_form_for(@user, layout: :horizontal) { |f| nil }
  end
  
  test "form with my html options" do
    expected = %{<form id="foo" class="bar" role="form" action="/users" accept-charset="UTF-8" method="post"><input name="utf8" type="hidden" value="&#x2713;" /></form>}
    assert_equal expected, bootstrap_form_for(@user, html: { id: "foo", class: "bar" }) { |f| nil }
  end
end