require 'test_helper'

class GlyphiconTest < ActionView::TestCase
  include BootstrapBuilder::Base
  
  test "glyphicon with my type" do
    expected = %{<span class="glyphicon glyphicon-thumbs-up" aria-hidden="true"></span>}
    assert_equal expected, bootstrap_glyphicon("thumbs-up")
  end
  
  test "glyphicon with my html options" do
    expected = %{<span id="foo" class="glyphicon glyphicon-thumbs-up bar" aria-hidden="true"></span>}
    assert_equal expected, bootstrap_glyphicon("thumbs-up", id: "foo", class: "bar")
  end
end