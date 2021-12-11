defmodule Day11Test do
  use ExUnit.Case
  doctest Day11

  setup_all do
    input_str = """
    5483143223
    2745854711
    5264556173
    6141336146
    6357385478
    4167524645
    2176841721
    6882881134
    4846848554
    5283751526
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

  test "step single", %{input: input} do
    {grid, n_flashes} = Day11.step(input)

    assert Day11.grid_to_str(grid) ==
             String.trim("""
             6594254334
             3856965822
             6375667284
             7252447257
             7468496589
             5278635756
             3287952832
             7993992245
             5957959665
             6394862637
             """)

    assert n_flashes == 0
    {grid2, n_flashes2} = Day11.step(grid)

    assert Day11.grid_to_str(grid2) ==
             String.trim("""
             8807476555
             5089087054
             8597889608
             8485769600
             8700908800
             6600088989
             6800005943
             0000007456
             9000000876
             8700006848
             """)

    assert n_flashes2 == 35
  end

  test "step with n", %{input: input} do
    assert elem(Day11.step(input, 10), 1) == 204
    assert elem(Day11.step(input, 100), 1) == 1656
  end

  test "step_until_all_flash", %{input: input} do
    assert Day11.step_until_all_flash(input) == 195
  end
end
