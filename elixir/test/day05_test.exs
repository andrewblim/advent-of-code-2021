defmodule Day05Test do
  use ExUnit.Case
  doctest Day05

  setup_all do
    input_str = """
    0,9 -> 5,9
    8,0 -> 0,8
    9,4 -> 3,4
    2,2 -> 2,1
    7,0 -> 7,4
    6,4 -> 2,0
    0,9 -> 2,9
    3,4 -> 1,4
    0,0 -> 8,8
    5,5 -> 8,2
    """

    input = input_str |> String.trim() |> String.split("\n") |> Enum.map(&Day05.parse_line/1)
    {:ok, %{input: input}}
  end

  test "get_horiz_vert_touches", %{input: input} do
    assert Day05.get_horiz_vert_touches(input) == %{
             {0, 9} => 2,
             {1, 4} => 1,
             {1, 9} => 2,
             {2, 1} => 1,
             {2, 2} => 1,
             {2, 4} => 1,
             {2, 9} => 2,
             {3, 4} => 2,
             {3, 9} => 1,
             {4, 4} => 1,
             {4, 9} => 1,
             {5, 4} => 1,
             {5, 9} => 1,
             {6, 4} => 1,
             {7, 0} => 1,
             {7, 1} => 1,
             {7, 2} => 1,
             {7, 3} => 1,
             {7, 4} => 2,
             {8, 4} => 1,
             {9, 4} => 1
           }
  end

  test "count_horiz_vert_overlaps", %{input: input} do
    assert Day05.count_horiz_vert_overlaps(input) == 5
  end

  test "count_all_overlaps", %{input: input} do
    assert Day05.count_all_overlaps(input) == 12
  end
end
