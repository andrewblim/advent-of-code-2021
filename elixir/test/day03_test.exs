defmodule Day03Test do
  use ExUnit.Case
  doctest Day03

  setup_all do
    input = ~w(
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
    ) |> Enum.map(fn x -> String.to_integer(x, 2) end)
    {:ok, input: input}
  end

  test "max_bit_index" do
    assert Day03.max_bit_index([0]) == 0
    assert Day03.max_bit_index([0, 1]) == 0
    assert Day03.max_bit_index([0, 1, 2]) == 1
    assert Day03.max_bit_index([0, 1, 2, 3]) == 1
    assert Day03.max_bit_index([0, 1, 2, 3, 4]) == 2
    assert Day03.max_bit_index([4]) == 2
  end

  test "count_bits_at", %{input: input} do
    assert Day03.count_bits_at(input, 0) == %{0 => 7, 1 => 5}
    assert Day03.count_bits_at(input, 1) == %{0 => 5, 1 => 7}
    assert Day03.count_bits_at(input, 2) == %{0 => 4, 1 => 8}
    assert Day03.count_bits_at(input, 3) == %{0 => 7, 1 => 5}
    assert Day03.count_bits_at(input, 4) == %{0 => 5, 1 => 7}
  end

  test "gamma_rate", %{input: input} do
    assert Day03.gamma_rate(input) == 22
  end

  test "epsilon_rate", %{input: input} do
    assert Day03.epsilon_rate(input) == 9
  end

  test "oxygen_rating", %{input: input} do
    assert Day03.oxygen_rating(input) == 23
  end

  test "co2_rating", %{input: input} do
    assert Day03.co2_rating(input) == 10
  end
end
