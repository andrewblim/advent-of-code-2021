defmodule Day08 do
  def parse_line(line) do
    [signal, output] = line |> String.split(" | ") |> Enum.map(fn x -> String.split(x, " ") end)
    {signal, output}
  end

  def read_input(file) do
    {:ok, file} = File.read(file)

    file
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&parse_line/1)
  end

  def n_easy_digits({_, output}) do
    easy_digit_counts = MapSet.new([2, 3, 4, 7])
    Enum.count(output, fn x ->
      MapSet.member?(easy_digit_counts, String.length(x))
    end)
  end

  def count_easy_digits(input) do
    input
    |> Enum.map(&n_easy_digits/1)
    |> Enum.sum()
  end

  def update_easy_candidates_single_entry(entry, candidates) do
    # candidates is a map from letters a-f to a set of letters a-f
    # in standard position that each letter could represent
    chars = MapSet.new(String.graphemes(entry))
    revision = case String.length(entry) do
      2 ->
        # must map to 1, which is on at c, f
        Map.new(
          ["a", "b", "c", "d", "e", "f", "g"],
          fn ch ->
            if MapSet.member?(chars, ch) do
              {ch, MapSet.new(["c", "f"])}
            else
              {ch, MapSet.new(["a", "b", "d", "e", "g"])}
            end
          end
        )
      3 ->
        # must map to 7, which is on at a, c, f
        Map.new(
          ["a", "b", "c", "d", "e", "f", "g"],
          fn ch ->
            if MapSet.member?(chars, ch) do
              {ch, MapSet.new(["a", "c", "f"])}
            else
              {ch, MapSet.new(["b", "d", "e", "g"])}
            end
          end
        )
      4 ->
        # must map to 4, which is on at b, c, d, f
        Map.new(
          ["a", "b", "c", "d", "e", "f", "g"],
          fn ch ->
            if MapSet.member?(chars, ch) do
              {ch, MapSet.new(["b", "c", "d", "f"])}
            else
              {ch, MapSet.new(["a", "e", "g"])}
            end
          end
        )
      7 ->
        # must map to 8, but this is unhelpful
        candidates
    end
    candidates |> Map.merge(revision, fn _k, v1, v2 -> MapSet.intersection(v1, v2) end)
  end

  def update_easy_candidates(entries, candidates) do
    entries |>
    Enum.filter(fn x -> not MapSet.member?(MapSet.new([5, 6]), String.length(x)) end) |>
    Enum.reduce(candidates, &update_easy_candidates_single_entry/2)
  end

  def update_hard_candidates(entries, candidates) do
    # 2, 3, 5
    fivers = Enum.filter(entries, fn x -> String.length(x) == 5 end)
      |> Enum.map(fn x -> MapSet.new(String.graphemes(x)) end)
    # 0, 6, 9
    sixers = Enum.filter(entries, fn x -> String.length(x) == 6 end)
    |> Enum.map(fn x -> MapSet.new(String.graphemes(x)) end)

    # a and g are used by all fivers and sixers
    # b is used by one fiver (5) and all sixers
    # c is used by two fivers (2, 3) and two sixers (0, 9)
    # d is used by all fivers and two sixers (6, 9)
    # e is used by one fiver (2) and two sixers (0, 6)
    # f is used by two fivers (3, 5) and all sixers
    revision = for ch <- ["a", "b", "c", "d", "e", "f", "g"], into: %{} do
      in_fivers = Enum.count(fivers, fn x -> MapSet.member?(x, ch) end)
      in_sixers = Enum.count(sixers, fn x -> MapSet.member?(x, ch) end)
      ch_candidates = cond do
        in_fivers == 3 and in_sixers == 3 ->
          MapSet.new(["a", "g"])
        in_fivers == 1 and in_sixers == 3 ->
          MapSet.new(["b"])
        in_fivers == 2 and in_sixers == 2 ->
          MapSet.new(["c"])
        in_fivers == 3 and in_sixers == 2 ->
          MapSet.new(["d"])
        in_fivers == 1 and in_sixers == 2 ->
          MapSet.new(["e"])
        in_fivers == 2 and in_sixers == 3 ->
          MapSet.new(["f"])
      end
      {ch, ch_candidates}
    end
    candidates |> Map.merge(revision, fn _k, v1, v2 -> MapSet.intersection(v1, v2) end)
  end

  def create_segment_mapping(candidates) do
    mapping = for ch <- ["a", "b", "c", "d", "e", "f", "g"], into: %{} do
      [x] = MapSet.to_list(candidates[ch])
      {ch, x}
    end
    if MapSet.new(Map.values(mapping)) != MapSet.new(["a", "b", "c", "d", "e", "f", "g"]) do
      raise "Non-unique mapping found"
    end
    mapping
  end

  def determine_mappings(signal) do
    candidates = Map.new(["a", "b", "c", "d", "e", "f", "g"], fn char ->
      {char, MapSet.new(["a", "b", "c", "d", "e", "f", "g"])}
    end)
    candidates = update_easy_candidates(signal, candidates)
    candidates = update_hard_candidates(signal, candidates)
    create_segment_mapping(candidates)
  end

  def determine_output(mapping, output) do
    remapped_output = output
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
      digits |> Enum.reverse() |> Enum.with_index() |> Enum.map(fn {x, i} -> x * Integer.pow(10, i) end) |> Enum.sum()
    end
  end
end
