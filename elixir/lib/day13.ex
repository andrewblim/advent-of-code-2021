defmodule Day13 do
  def read_input(file) do
    {:ok, file} = File.read(file)
    parse_input(file)
  end

  def parse_input(raw_input) do
    [dots, instructions] =
      raw_input
      |> String.trim()
      |> String.split("\n\n")
      |> Enum.map(fn x -> String.split(x, "\n") end)

    paper =
      for dot <- dots, into: %{} do
        [x, y] = String.split(dot, ",") |> Enum.map(&String.to_integer/1)
        {{x, y}, :dot}
      end

    instructions =
      for inst <- instructions do
        [axis, n] = inst |> String.replace_prefix("fold along ", "") |> String.split("=")
        {axis, String.to_integer(n)}
      end

    {paper, instructions}
  end

  def fold(paper, instruction) do
    case instruction do
      {"x", n} -> fold_left(paper, n)
      {"y", n} -> fold_up(paper, n)
    end
  end

  def fold_left(paper, n) do
    for {x, y} <- Map.keys(paper), x != n, into: %{} do
      cond do
        x < n -> {{x, y}, :dot}
        x > n -> {{2 * n - x, y}, :dot}
      end
    end
  end

  def fold_up(paper, n) do
    for {x, y} <- Map.keys(paper), y != n, into: %{} do
      cond do
        y < n -> {{x, y}, :dot}
        y > n -> {{x, 2 * n - y}, :dot}
      end
    end
  end

  def fold_all(paper, instructions) do
    for inst <- instructions, reduce: paper do
      acc -> fold(acc, inst)
    end
  end

  def print_paper(paper) do
    max_x = Map.keys(paper) |> Enum.map(fn {x, _} -> x end) |> Enum.max()
    max_y = Map.keys(paper) |> Enum.map(fn {_, y} -> y end) |> Enum.max()
    {max_x, max_y}

    for y <- 0..max_y do
      for x <- 0..max_x do
        if Map.has_key?(paper, {x, y}), do: IO.write("#"), else: IO.write(".")
      end

      IO.write("\n")
    end

    nil
  end
end
