defmodule Day14 do
  def read_input(file) do
    {:ok, file} = File.read(file)
    parse_input(file)
  end

  def parse_input(raw_input) do
    [template, rule_rows] =
      raw_input
      |> String.trim()
      |> String.split("\n\n")

    rules =
      for row <- String.split(rule_rows, "\n"), into: %{} do
        [from, to] = String.split(row, " -> ")
        [from1, from2] = String.graphemes(from)
        {{from1, from2}, to}
      end

    {String.graphemes(template), rules}
  end

  def polymerize(template, rules) do
    new_template =
      template
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.flat_map(fn [ch1, ch2] ->
        if rules[{ch1, ch2}] != nil do
          [rules[{ch1, ch2}], ch2]
        else
          [ch2]
        end
      end)

    [Enum.at(template, 0) | new_template]
  end

  def polymerize(template, rules, n) do
    for _ <- 1..n//1, reduce: template do
      acc -> polymerize(acc, rules)
    end
  end

  def score_polymer(polymer) do
    # TODO make it return nicely
    Enum.frequencies(polymer)
  end

  def template_to_pair_freq(template) do
    template
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [x, y] -> {x, y} end)
    |> Enum.frequencies()
  end

  def polymerize_pair_freq(freq, rules) do
    for {x, y} <- Map.keys(freq), reduce: %{} do
      acc ->
        z = rules[{x, y}]

        merge_map =
          if z do
            %{{x, z} => freq[{x, y}], {z, y} => freq[{x, y}]}
          else
            %{{x, y} => freq[{x, y}]}
          end

        Map.merge(acc, merge_map, fn _, v1, v2 -> v1 + v2 end)
    end
  end

  def polymerize_pair_freq(freq, rules, n) do
    for _ <- 1..n//1, reduce: freq do
      acc -> polymerize_pair_freq(acc, rules)
    end
  end

  def polymerize_freq(template, rules, n) do
    pair_freq =
      template
      |> template_to_pair_freq()
      |> polymerize_pair_freq(rules, n)

    freq =
      for {x, y} <- Map.keys(pair_freq), reduce: %{} do
        acc ->
          acc
          |> Map.merge(%{x => pair_freq[{x, y}]}, fn _, v1, v2 -> v1 + v2 end)
          |> Map.merge(%{y => pair_freq[{x, y}]}, fn _, v1, v2 -> v1 + v2 end)
      end

    # everything's double counted, though we need to add 1 for the
    # first and last characters in template for them to be double counted too
    freq = Map.update!(freq, List.first(template), &(&1 + 1))
    freq = Map.update!(freq, List.last(template), &(&1 + 1))
    for {k, v} <- freq, into: %{}, do: {k, round(v / 2)}
  end
end
