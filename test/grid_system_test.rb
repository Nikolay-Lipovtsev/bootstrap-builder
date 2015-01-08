require 'test_helper'

class GridSystemTest < ActionView::TestCase
  include BootstrapBuilder
  
  test "bootstrap row" do
    expected = %{<div class="row">Test</div>}
    assert_equal expected, bootstrap_row { "Test" }
  end
  
  test "bootstrap row with disabled option" do
    expected = %{Test}
    assert_equal expected, bootstrap_row(row_disabled: true) { "Test" }
  end
  
  test "bootstrap row with my html options" do
    expected = %{<div id="foo" class="row bar">Test</div>}
    assert_equal expected, bootstrap_row(id: "foo", class: "bar") { "Test" }
  end
  
  test "bootstrap column" do
    expected = %{<div class="col-md-12">Test</div>}
    assert_equal expected, bootstrap_col { "Test" }
  end
  
  test "bootstrap column with my column and offsetting column numbers" do
    expected = %{<div class="col-md-2 col-md-offset-4">Test</div>}
    assert_equal expected, bootstrap_col(col: 2, offset_col: 4) { "Test" }
  end
  
  test "bootstrap column with my grid system class" do
    expected = %{<div class="col-xs-12">Test</div>}
    assert_equal expected, bootstrap_col(grid_system: "xs") { "Test" }
  end
  
  test "bootstrap column with disabled option" do
    expected = %{Test}
    assert_equal expected, bootstrap_col(col_disabled: true) { "Test" }
  end
  
  test "bootstrap column with my html options" do
    expected = %{<div id="foo" class="col-md-12 bar">Test</div>}
    assert_equal expected, bootstrap_col(id: "foo", class: "bar") { "Test" }
  end
  
  test "bootstrap row with column" do
    expected = %{<div class="row"><div class="col-md-12">Test</div></div>}
    assert_equal expected, bootstrap_row_with_col { "Test" }
  end
  
  test "bootstrap row with column and my column and offsetting column numbers" do
    expected = %{<div class="row"><div class="col-md-2 col-md-offset-4">Test</div></div>}
    assert_equal expected, bootstrap_row_with_col(col: 2, offset_col: 4) { "Test" }
  end
  
  test "bootstrap row with column and my grid system class" do
    expected = %{<div class="row"><div class="col-xs-12">Test</div></div>}
    assert_equal expected, bootstrap_row_with_col(grid_system: "xs") { "Test" }
  end
  
  test "bootstrap row with column and with row disabled option" do
    expected = %{<div class="col-md-12">Test</div>}
    assert_equal expected, bootstrap_row_with_col(row_disabled: true) { "Test" }
  end
  
  test "bootstrap row with column and with column disabled option" do
    expected = %{<div class="row">Test</div>}
    assert_equal expected, bootstrap_row_with_col(col_disabled: true) { "Test" }
  end
  
  test "bootstrap row with column and with my html options" do
    expected = %{<div id="foo" class="row bar"><div class="col-md-12">Test</div></div>}
    assert_equal expected, bootstrap_row_with_col(id: "foo", class: "bar") { "Test" }
  end
end