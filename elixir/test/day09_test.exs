defmodule Day09Test do
  use ExUnit.Case
  doctest Day08

  setup_all do
    input_str = """
    2199943210
    3987894921
    9856789892
    8767896789
    9899965678
    """

    input =
      input_str
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(fn row -> String.graphemes(row) |> Enum.map(&String.to_integer/1) end)

    input =
      for {row, i} <- Enum.with_index(input), {x, j} <- Enum.with_index(row), into: %{} do
        {{i, j}, x}
      end

    {:ok, %{input: input}}
  end

  test "find_low_points", %{input: input} do
    assert Enum.sort(Day09.find_low_points(input)) == [{0, 1}, {0, 9}, {2, 2}, {4, 6}]
  end

  test "risk_low_points", %{input: input} do
    assert Day09.risk_low_points(input) == 15
  end

  test "basin", %{input: input} do
    assert Day09.basin(input, {0, 1}) == MapSet.new([{0, 0}, {0, 1}, {1, 0}])

    assert Day09.basin(input, {0, 9}) ==
             MapSet.new([{0, 5}, {0, 6}, {0, 7}, {0, 8}, {0, 9}, {1, 6}, {1, 8}, {1, 9}, {2, 9}])
  end

  test "basin_sizes", %{input: input} do
    assert Enum.sort(Day09.basin_sizes(input)) == [3, 9, 9, 14]
  end

  test "top_basin_sizes_product", %{input: input} do
    assert Day09.top_basin_sizes(input, 3) == 1134
  end
end
