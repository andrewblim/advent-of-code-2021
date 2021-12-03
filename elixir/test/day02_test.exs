defmodule Day02Test do
  use ExUnit.Case
  doctest Day02

  test "move" do
    assert Day02.move({"forward", 5}, {0, 0}) == {5, 0}
    assert Day02.move({"down", 10}, {0, 0}) == {0, 10}
    assert Day02.move({"up", 15}, {0, 0}) == {0, -15}
  end

  test "navigate" do
    assert Day02.navigate([
             {"forward", 5},
             {"down", 5},
             {"forward", 8},
             {"up", 3},
             {"down", 8},
             {"forward", 2}
           ]) == {15, 10}
  end

  test "move2" do
    assert Day02.move2({"forward", 5}, {0, 0, 0}) == {5, 0, 0}
    assert Day02.move2({"down", 5}, {0, 0, 0}) == {0, 0, 5}
    assert Day02.move2({"forward", 8}, {0, 0, 5}) == {8, 40, 5}
  end

  test "navigate2" do
    assert Day02.navigate2([
             {"forward", 5},
             {"down", 5},
             {"forward", 8},
             {"up", 3},
             {"down", 8},
             {"forward", 2}
           ]) == {15, 60, 10}
  end
end
