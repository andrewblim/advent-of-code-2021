defmodule Day04 do
  def make_empty_board(str) do
    String.trim(str)
    |> String.split(~r"\s+")
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {x, i}, acc ->
      Map.put(acc, {floor(i / 5), rem(i, 5)}, {String.to_integer(x), false})
    end)
  end

  def read_input(file) do
    {:ok, file} = File.read(file)
    [draws | boards] = file |> String.trim() |> String.split("\n\n")
    draws = String.split(draws, ",") |> Enum.map(&String.to_integer/1)
    boards = Enum.map(boards, &make_empty_board/1)
    {draws, boards}
  end

  def mark_board(board, draw) do
    matches = Map.keys(board) |> Enum.filter(fn k -> board[k] |> elem(0) == draw end)
    updates = Map.new(matches, fn k -> {k, {draw, true}} end)
    Map.merge(board, updates)
  end

  def victory?(board) do
    horiz_victory?(board) or vert_victory?(board)
  end

  def horiz_victory?(board) do
    Enum.any?(0..4, fn row ->
      Enum.all?(0..4, fn col -> board[{row, col}] |> elem(1) end)
    end)
  end

  def vert_victory?(board) do
    Enum.any?(0..4, fn col ->
      Enum.all?(0..4, fn row -> board[{row, col}] |> elem(1) end)
    end)
  end

  def play_bingo(draws, boards) do
    case draws do
      [] ->
        raise "No winners"

      [draw | rest] ->
        marked_boards = Enum.map(boards, fn board -> mark_board(board, draw) end)
        winners = Enum.filter(marked_boards, &victory?/1)

        case winners do
          [] -> play_bingo(rest, marked_boards)
          _ -> {winners, draw}
        end
    end
  end

  def score_result({winners, draw}) do
    Enum.map(winners, fn winner ->
      board_score =
        Map.values(winner)
        |> Enum.reduce(0, fn {v, mark}, acc -> if mark, do: acc, else: acc + v end)

      board_score * draw
    end)
  end

  def play_bingo_to_last_winner(draws, boards) do
    case draws do
      [] ->
        raise "Not all boards eventually won"

      [draw | rest] ->
        marked_boards = Enum.map(boards, fn board -> mark_board(board, draw) end)
        non_winners = Enum.filter(marked_boards, fn board -> not victory?(board) end)

        case non_winners do
          [] -> {marked_boards, draw}
          _ -> play_bingo_to_last_winner(rest, non_winners)
        end
    end
  end
end
