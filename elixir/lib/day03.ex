defmodule Day03 do
  def read_input(file) do
    {:ok, file} = File.read(file)
    file |>
      String.trim() |>
      String.split("\n") |>
      Enum.map(&String.graphemes/1)
  end

  def count_bits_by_position(graphemes) do
    Enum.map(graphemes, fn x ->
      case x do
        "0" -> %{0 => 1, 1 => 0}
        "1" -> %{0 => 0, 1 => 1}
      end
    end)
  end

  def total_bits_by_position(input) do
    Enum.map(input, &count_bits_by_position/1) |>
      Enum.reduce(fn x, y ->
        Enum.zip(x, y) |> Enum.map(fn {x1, y1} ->
          Map.merge(x1, y1, fn _k, v1, v2 -> v1 + v2 end)
        end)
      end)
  end

  def gamma_rate(counts) do
    counts |> Enum.reverse() |> Enum.with_index() |>
      Enum.reduce(0, fn {count, i}, acc ->
        if count[1] > count[0] do
          acc + :math.pow(2, i)
        else
          acc
        end
      end) |> round()
  end

  def epsilon_rate(counts) do
    counts |> Enum.reverse() |> Enum.with_index() |>
      Enum.reduce(0, fn {count, i}, acc ->
        if count[1] < count[0] do
          acc + :math.pow(2, i)
        else
          acc
        end
      end) |> round()
  end

  def count_bits_at_position(graphemes, i) do
    case Enum.at(graphemes, i) do
      "0" -> %{0 => 1, 1 => 0}
      "1" -> %{0 => 0, 1 => 1}
    end
  end

  def total_bits_at_position(input, i) do
    Enum.map(input, fn x -> count_bits_at_position(x, i) end) |>
      Enum.reduce(fn x, y ->
        Map.merge(x, y, fn _k, v1, v2 -> v1 + v2 end)
      end)
  end

  def filter_for_oxygen_rating(input, i) do
    case input do
      [] -> raise "Filtered everything"
      [x] -> x
      _ ->
        totals = total_bits_at_position(input, i)
        most_common = if totals[0] > totals[1], do: "0", else: "1"
        filter_for_oxygen_rating(
          Enum.filter(input, fn x -> Enum.at(x, i) == most_common end),
          i + 1
        )
    end
  end

  def oxygen_rating(input) do
    filter_for_oxygen_rating(input, 0) |> Enum.join() |> String.to_integer(2)
  end

  def filter_for_co2_rating(input, i) do
    case input do
      [] -> raise "Filtered everything"
      [x] -> x
      _ ->
        totals = total_bits_at_position(input, i)
        most_common = if totals[1] < totals[0], do: "1", else: "0"
        filter_for_co2_rating(
          Enum.filter(input, fn x -> Enum.at(x, i) == most_common end),
          i + 1
        )
    end
  end

  def co2_rating(input) do
    filter_for_co2_rating(input, 0) |> Enum.join() |> String.to_integer(2)
  end
end
