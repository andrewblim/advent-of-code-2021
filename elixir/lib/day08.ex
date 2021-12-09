defmodule Day08 do
  def parse_line(line) do
    [signal, output] = line |> String.split(" | ")
    # Turn the signal into sets of letters, leave the output as strings
    signal = signal |> String.split(" ") |> Enum.map(fn y -> MapSet.new(String.graphemes(y)) end)
    output = String.split(output, " ")
    {signal, output}
  end

  def read_input(file) do
    {:ok, file} = File.read(file)

    file
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&parse_line/1)
  end

  def n_easy_digits_in_output({_, output}) do
    easy_digit_counts = MapSet.new([2, 3, 4, 7])

    Enum.count(output, fn x ->
      MapSet.member?(easy_digit_counts, String.length(x))
    end)
  end

  def count_easy_digits_in_output(input) do
    input
    |> Enum.map(&n_easy_digits_in_output/1)
    |> Enum.sum()
  end

  def determine_mappings(signal) do
    # digits by segment count: 2 = {1}, 3 = {7}, 4 = {4}, 5 = {2,3,5}, 6 = {0,6,9}
    signal_by_count = signal |> Enum.group_by(&MapSet.size/1)

    # a and g are used by all fivers and sixers, but:
    #   a is used by the lone 3
    #   g is the other one
    # b is used by one fiver (5) and all sixers
    # c is used by two fivers (2, 3) and two sixers (0, 9)
    # d is used by all fivers and two sixers (6, 9)
    # e is used by one fiver (2) and two sixers (0, 6)
    # f is used by two fivers (3, 5) and all sixers
    for ch <- ["a", "b", "c", "d", "e", "f", "g"], into: %{} do
      in_fivers = Enum.count(signal_by_count[5], fn x -> MapSet.member?(x, ch) end)
      in_sixers = Enum.count(signal_by_count[6], fn x -> MapSet.member?(x, ch) end)

      ch_candidates =
        cond do
          in_fivers == 3 and in_sixers == 3 ->
            in_threers = Enum.count(signal_by_count[3], fn x -> MapSet.member?(x, ch) end)

            if in_threers == 1 do
              "a"
            else
              "g"
            end

          in_fivers == 1 and in_sixers == 3 ->
            "b"

          in_fivers == 2 and in_sixers == 2 ->
            "c"

          in_fivers == 3 and in_sixers == 2 ->
            "d"

          in_fivers == 1 and in_sixers == 2 ->
            "e"

          in_fivers == 2 and in_sixers == 3 ->
            "f"
        end

      {ch, ch_candidates}
    end
  end

  def determine_output(mapping, output) do
    remapped_output =
      output
      |> String.graphemes()
      |> Enum.map(fn ch -> mapping[ch] end)
      |> Enum.sort()
      |> Enum.join("")

    case remapped_output do
      "abcefg" -> 0
      "cf" -> 1
      "acdeg" -> 2
      "acdfg" -> 3
      "bcdf" -> 4
      "abdfg" -> 5
      "abdefg" -> 6
      "acf" -> 7
      "abcdefg" -> 8
      "abcdfg" -> 9
      _ -> raise "Unrecognized translation"
    end
  end

  def compute_digits(input) do
    for {signal, output} <- input do
      mapping = determine_mappings(signal)
      digits = Enum.map(output, fn x -> determine_output(mapping, x) end)

      digits
      |> Enum.reverse()
      |> Enum.with_index()
      |> Enum.map(fn {x, i} -> x * Integer.pow(10, i) end)
      |> Enum.sum()
    end
  end
end
