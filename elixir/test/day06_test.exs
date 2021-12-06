defmodule Day06Test do
  use ExUnit.Case
  doctest Day05

  test "total_fish_after" do
    input = [3, 4, 3, 1, 2] |> Enum.frequencies()
    assert Day06.total_fish_after(input, 0) == 5
    assert Day06.total_fish_after(input, 1) == 5
    assert Day06.total_fish_after(input, 2) == 6
    assert Day06.total_fish_after(input, 10) == 12
    assert Day06.total_fish_after(input, 18) == 26
  end
end
