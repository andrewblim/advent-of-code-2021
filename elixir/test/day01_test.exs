defmodule Day01Test do
  use ExUnit.Case
  doctest Day01

  test "simple depth" do
    assert Day01.n_increases([199, 200, 208, 210, 200, 207, 240, 269, 260, 263]) == 7
  end

  test "window depth" do
    assert Day01.n_increases([199, 200, 208, 210, 200, 207, 240, 269, 260, 263], 3) == 5
  end
end
