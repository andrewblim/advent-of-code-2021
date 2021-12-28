defmodule Day25 do
  def read_input(file) do
    {:ok, file} = File.read(file)
    parse_input(file)
  end

  def parse_input(raw_input) do
    rows =
      raw_input
      |> String.trim()
      |> String.split("\n")

    for {row, i} <- Enum.with_index(rows),
        {ch, j} <- Enum.with_index(String.graphemes(row)),
        into: %{} do
      {{i, j}, ch}
    end
  end

  def step(map, n \\ 1) do
    if n == 0 do
      map
    else
      map |> step_east() |> step_south() |> step(n - 1)
    end
  end

  def step_until_frozen(map, n \\ 0) do
    next_map = map |> step_east |> step_south()

    case next_map do
      ^map -> n + 1
      _ -> step_until_frozen(next_map, n + 1)
    end
  end

  def print_map(map) do
    {max_i, max_j} = Map.keys(map) |> Enum.max()

    for i <- 0..max_i do
      for j <- 0..max_j do
        IO.write(map[{i, j}])
      end

      IO.write("\n")
    end

    nil
  end

  def step_east(map) do
    {_, max_j} = Map.keys(map) |> Enum.max()

    for {{i, j}, v} <- map, reduce: %{} do
      acc ->
        cond do
          Map.has_key?(acc, {i, j}) ->
            acc

          v == ">" ->
            if map[{i, rem(j + 1, max_j + 1)}] == "." do
              update = %{
                {i, j} => ".",
                {i, rem(j + 1, max_j + 1)} => v
              }

              Map.merge(acc, update)
            else
              Map.put(acc, {i, j}, v)
            end

          true ->
            Map.put(acc, {i, j}, v)
        end
    end
  end

  def step_south(map) do
    {max_i, _} = Map.keys(map) |> Enum.max()

    for {{i, j}, v} <- map, reduce: %{} do
      acc ->
        cond do
          Map.has_key?(acc, {i, j}) ->
            acc

          v == "v" ->
            if map[{rem(i + 1, max_i + 1), j}] == "." do
              update = %{
                {i, j} => ".",
                {rem(i + 1, max_i + 1), j} => v
              }

              Map.merge(acc, update)
            else
              Map.put(acc, {i, j}, v)
            end

          true ->
            Map.put(acc, {i, j}, v)
        end
    end
  end
end
