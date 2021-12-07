defmodule Day07Test do
  use ExUnit.Case
  doctest Day07

  test "fuel_required" do
    assert Day07.fuel_required([16,1,2,0,4,2,7,1,2,14]) == {2, 37}
  end

  test "fuel_required2" do
    assert Day07.fuel_required2([16,1,2,0,4,2,7,1,2,14]) == {5, 168}
  end
end
