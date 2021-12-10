defmodule Day10 do
  def read_input(file) do
    {:ok, file} = File.read(file)

    file
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.graphemes/1)
  end

  def check_line(line) do
    line
    |> Enum.reduce_while([], &check_char/2)
  end

  def check_char(ch, stack) do
    case {ch, stack} do
      {_, _} when ch == "(" or ch == "[" or ch == "{" or ch == "<" ->
        {:cont, [ch | stack]}

      {_, [head | tail]}
      when (head == "(" and ch == ")") or (head == "[" and ch == "]") or
             (head == "{" and ch == "}") or (head == "<" and ch == ">") ->
        {:cont, tail}

      {_, _} ->
        {:halt, {:corrupt, ch}}
    end
  end

  def grade_line(line) do
    case check_line(line) do
      {:corrupt, ")"} -> {:corrupt, 3}
      {:corrupt, "]"} -> {:corrupt, 57}
      {:corrupt, "}"} -> {:corrupt, 1197}
      {:corrupt, ">"} -> {:corrupt, 25137}
      [] -> {:ok, []}
      stack -> {:incomplete, stack}
    end
  end

  def grade_all_corrupt_lines(lines) do
    lines
    |> Enum.map(&grade_line/1)
    |> Enum.filter(fn x -> match?({:corrupt, _}, x) end)
    |> Enum.map(fn {_, x} -> x end)
    |> Enum.sum()
  end

  def grade_incomplete_stack(stack) do
    Enum.reduce(stack, 0, fn x, acc ->
      acc * 5 +
        case x do
          "(" -> 1
          "[" -> 2
          "{" -> 3
          "<" -> 4
        end
    end)
  end

  def grades_of_all_non_corrupt_lines(lines) do
    lines
    |> Enum.map(&grade_line/1)
    |> Enum.filter(fn x -> not match?({:corrupt, _}, x) end)
    |> Enum.map(fn {_, stack} -> grade_incomplete_stack(stack) end)
    |> Enum.sort()
  end

  def median_grade_of_all_non_corrupt_lines(lines) do
    grades = grades_of_all_non_corrupt_lines(lines)
    Enum.at(grades, floor(length(grades) / 2))
  end
end
