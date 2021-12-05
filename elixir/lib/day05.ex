defmodule Day05 do
  def parse_line(str) do
    [x1, y1, x2, y2] = str
      |> String.split([",", "->"])
      |> Enum.map(fn x -> x |> String.trim() |> String.to_integer end)
    {{x1, y1}, {x2, y2}}
  end

  def read_input(file) do
    {:ok, file} = File.read(file)
    file |> String.trim() |> String.split("\n") |> Enum.map(&parse_line/1)
  end

  def is_horiz?({{_, y1}, {_, y2}}) do
    y1 == y2
  end

  def is_vert?({{x1, _}, {x2, _}}) do
    x1 == x2
  end

  def get_horiz_vert_touches(lines) do
    Enum.reduce(lines, %{}, fn {{x1, y1}, {x2, y2}}, acc->
      cond do
        is_horiz?({{x1, y1}, {x2, y2}}) ->
          pts = Map.new(x1..x2, fn k -> {{k, y1}, 1} end)
          Map.merge(acc, pts, fn _k, v1, v2 -> v1 + v2 end)
        is_vert?({{x1, y1}, {x2, y2}}) ->
          pts = Map.new(y1..y2, fn k -> {{x1, k}, 1} end)
          Map.merge(acc, pts, fn _k, v1, v2 -> v1 + v2 end)
        true -> acc
      end
    end)
  end

  def count_horiz_vert_overlaps(lines) do
    get_horiz_vert_touches(lines) |> Enum.count(fn {_, v} -> v > 1 end)
  end

  def get_all_touches(lines) do
    Enum.reduce(lines, %{}, fn {{x1, y1}, {x2, y2}}, acc->
      pts = cond do
        is_horiz?({{x1, y1}, {x2, y2}}) ->
          Map.new(x1..x2, fn k -> {{k, y1}, 1} end)
        is_vert?({{x1, y1}, {x2, y2}}) ->
          Map.new(y1..y2, fn k -> {{x1, k}, 1} end)
        true ->
          Map.new(Enum.zip(x1..x2, y1..y2), fn k -> {k, 1} end)
      end
      Map.merge(acc, pts, fn _k, v1, v2 -> v1 + v2 end)
    end)
  end

  def count_all_overlaps(lines) do
    get_all_touches(lines) |> Enum.count(fn {_, v} -> v > 1 end)
  end
end
