defmodule Day03 do
  def read_input(file) do
    {:ok, file} = File.read(file)

    file
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn x -> String.to_integer(x, 2) end)
  end

  def max_bit_index(input) do
    Enum.map(input, fn
      x when x == 0 -> 0
      x -> :math.log2(x) |> floor()
    end)
    |> Enum.max()
  end

  def count_bits_at(input, i) do
    use Bitwise

    Enum.map(input, fn x -> rem(x >>> i, 2) end)
    |> Enum.reduce(%{0 => 0, 1 => 0}, fn x, acc -> %{acc | x => acc[x] + 1} end)
  end

  def gamma_rate(input) do
    Enum.map(0..max_bit_index(input), fn i ->
      counts = count_bits_at(input, i)
      if counts[0] < counts[1], do: :math.pow(2, i), else: 0
    end)
    |> Enum.sum()
    |> round()
  end

  def epsilon_rate(input) do
    Enum.map(0..max_bit_index(input), fn i ->
      counts = count_bits_at(input, i)
      if counts[0] < counts[1], do: 0, else: :math.pow(2, i)
    end)
    |> Enum.sum()
    |> round()
  end

  def filter_for_oxygen_rating(input, i) do
    use Bitwise

    case input do
      [] ->
        raise "Filtered everything"

      [x] ->
        x

      _ ->
        counts = count_bits_at(input, i)
        most_common = if counts[0] > counts[1], do: 0, else: 1

        filter_for_oxygen_rating(
          Enum.filter(input, fn x -> rem(x >>> i, 2) == most_common end),
          i - 1
        )
    end
  end

  def oxygen_rating(input) do
    filter_for_oxygen_rating(input, max_bit_index(input))
  end

  def filter_for_co2_rating(input, i) do
    use Bitwise

    case input do
      [] ->
        raise "Filtered everything"

      [x] ->
        x

      _ ->
        counts = count_bits_at(input, i)
        least_common = if counts[1] < counts[0], do: 1, else: 0

        filter_for_co2_rating(
          Enum.filter(input, fn x -> rem(x >>> i, 2) == least_common end),
          i - 1
        )
    end
  end

  def co2_rating(input) do
    filter_for_co2_rating(input, max_bit_index(input))
  end
end
