defmodule Day03Test do
  use ExUnit.Case
  doctest Day03

  test "count_bits_by_position" do
    assert Day03.count_bits_by_position(["0", "1"]) == [
      %{0 => 1, 1 => 0}, %{0 => 0, 1 => 1}
    ]
  end

  test "total_bits_by_position" do
    input = Enum.map(~w(
      00100
      11110
      10110
      10111
      10101
      01111
      00111
      11100
      10000
      11001
      00010
      01010
    ), &String.graphemes/1)
    assert Day03.total_bits_by_position(input) == [
      %{0 => 5, 1 => 7},
      %{0 => 7, 1 => 5},
      %{0 => 4, 1 => 8},
      %{0 => 5, 1 => 7},
      %{0 => 7, 1 => 5},
    ]
  end

  test "gamma_rate" do
    assert Day03.gamma_rate([
      %{0 => 5, 1 => 7},
      %{0 => 7, 1 => 5},
      %{0 => 4, 1 => 8},
      %{0 => 5, 1 => 7},
      %{0 => 7, 1 => 5},
    ]) == 22
  end

  test "epsilon_rate" do
    assert Day03.epsilon_rate([
      %{0 => 5, 1 => 7},
      %{0 => 7, 1 => 5},
      %{0 => 4, 1 => 8},
      %{0 => 5, 1 => 7},
      %{0 => 7, 1 => 5},
    ]) == 9
  end

  test "oxygen_rating" do
    input = Enum.map(~w(
      00100
      11110
      10110
      10111
      10101
      01111
      00111
      11100
      10000
      11001
      00010
      01010
    ), &String.graphemes/1)
    assert Day03.oxygen_rating(input) == 23
  end

  test "co2_rating" do
    input = Enum.map(~w(
      00100
      11110
      10110
      10111
      10101
      01111
      00111
      11100
      10000
      11001
      00010
      01010
    ), &String.graphemes/1)
    assert Day03.co2_rating(input) == 10
  end
end
