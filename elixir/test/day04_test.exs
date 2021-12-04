defmodule Day04Test do
  use ExUnit.Case
  doctest Day04

  setup_all do
    input = """
    7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

    22 13 17 11  0
     8  2 23  4 24
    21  9 14 16  7
     6 10  3 18  5
     1 12 20 15 19

     3 15  0  2 22
     9 18 13 17  5
    19  8  7 25 23
    20 11 10 24  4
    14 21 16 12  6

    14 21 17 24  4
    10 16 15  9 19
    18  8 23 26 20
    22 11 13  6  5
     2  0 12  3  7
    """

    [draws | boards] = input |> String.trim() |> String.split("\n\n")
    draws = String.split(draws, ",") |> Enum.map(&String.to_integer/1)
    boards = Enum.map(boards, &Day04.make_empty_board/1)
    {:ok, %{draws: draws, boards: boards}}
  end

  test "make_empty_board" do
    input = """
      22 13 17 11  0
       8  2 23  4 24
      21  9 14 16  7
       6 10  3 18  5
       1 12 20 15 19
    """

    assert Day04.make_empty_board(input) == %{
             {0, 0} => {22, false},
             {0, 1} => {13, false},
             {0, 2} => {17, false},
             {0, 3} => {11, false},
             {0, 4} => {0, false},
             {1, 0} => {8, false},
             {1, 1} => {2, false},
             {1, 2} => {23, false},
             {1, 3} => {4, false},
             {1, 4} => {24, false},
             {2, 0} => {21, false},
             {2, 1} => {9, false},
             {2, 2} => {14, false},
             {2, 3} => {16, false},
             {2, 4} => {7, false},
             {3, 0} => {6, false},
             {3, 1} => {10, false},
             {3, 2} => {3, false},
             {3, 3} => {18, false},
             {3, 4} => {5, false},
             {4, 0} => {1, false},
             {4, 1} => {12, false},
             {4, 2} => {20, false},
             {4, 3} => {15, false},
             {4, 4} => {19, false}
           }
  end

  test "mark_board", %{boards: boards} do
    board = Enum.at(boards, 0)
    assert board |> Map.get({2, 2}) == {14, false}
    assert board |> Day04.mark_board(14) |> Map.get({2, 2}) == {14, true}
  end

  test "victory?", %{boards: boards} do
    board = Enum.at(boards, 0)
    assert board |> Day04.victory?() == false

    assert board
           |> Day04.mark_board(22)
           |> Day04.mark_board(13)
           |> Day04.mark_board(17)
           |> Day04.mark_board(11)
           |> Day04.mark_board(0)
           |> Day04.victory?() == true

    assert board
           |> Day04.mark_board(22)
           |> Day04.mark_board(8)
           |> Day04.mark_board(21)
           |> Day04.mark_board(6)
           |> Day04.mark_board(1)
           |> Day04.victory?() == true
  end

  test "play_bingo", %{draws: draws, boards: boards} do
    assert Day04.play_bingo(draws, boards) == {
             [
               Enum.at(boards, 2)
               |> Day04.mark_board(14)
               |> Day04.mark_board(21)
               |> Day04.mark_board(17)
               |> Day04.mark_board(24)
               |> Day04.mark_board(4)
               |> Day04.mark_board(9)
               |> Day04.mark_board(23)
               |> Day04.mark_board(11)
               |> Day04.mark_board(5)
               |> Day04.mark_board(2)
               |> Day04.mark_board(0)
               |> Day04.mark_board(7)
             ],
             24
           }
  end

  test "play_bingo_to_last_winner", %{draws: draws, boards: boards} do
    assert Day04.play_bingo_to_last_winner(draws, boards) == {
             [
               Enum.at(boards, 1)
               |> Day04.mark_board(7)
               |> Day04.mark_board(4)
               |> Day04.mark_board(9)
               |> Day04.mark_board(5)
               |> Day04.mark_board(11)
               |> Day04.mark_board(17)
               |> Day04.mark_board(23)
               |> Day04.mark_board(2)
               |> Day04.mark_board(0)
               |> Day04.mark_board(14)
               |> Day04.mark_board(21)
               |> Day04.mark_board(24)
               |> Day04.mark_board(10)
               |> Day04.mark_board(16)
               |> Day04.mark_board(13)
             ],
             13
           }
  end

  test "score_result", %{draws: draws, boards: boards} do
    assert Day04.play_bingo(draws, boards) |> Day04.score_result() == [4512]
    assert Day04.play_bingo_to_last_winner(draws, boards) |> Day04.score_result() == [1924]
  end
end
