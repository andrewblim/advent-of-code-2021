defmodule Day15 do
  def read_input(file) do
    {:ok, file} = File.read(file)
    parse_input(file)
  end

  def parse_input(raw_input) do
    input =
      raw_input
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(&String.graphemes(&1))

    for {row, y} <- Enum.with_index(input), {risk, x} <- Enum.with_index(row), into: %{} do
      {{x, y}, String.to_integer(risk)}
    end
  end

  def update_score({x, y}, scores, map) do
    possibles =
      for neighbor <- [{x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}], scores[neighbor] != nil do
        scores[neighbor] + map[{x, y}]
      end

    case possibles do
      [] ->
        scores

      _ ->
        min_possible = Enum.min(possibles)
        Map.put(scores, {x, y}, min(scores[{x, y}], min_possible))
    end
  end

  def update_scores(pts, scores, map) do
    for pt <- pts, reduce: scores do
      acc -> update_score(pt, acc, map)
    end
  end

  def best_scores(pts, scores, map) do
    updated_scores = update_scores(pts, scores, map)
    changed_pts = Enum.filter(pts, fn pt -> updated_scores[pt] != scores[pt] end)

    impacted_pts =
      for {x, y} <- changed_pts,
          neighbor <- [{x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}],
          map[neighbor] != nil,
          into: MapSet.new() do
        neighbor
      end

    cond do
      scores == updated_scores -> scores
      true -> best_scores(impacted_pts, updated_scores, map)
    end
  end

  def best_scores(map) do
    scores = for k <- Map.keys(map), into: %{}, do: {k, nil}
    scores = Map.put(scores, {0, 0}, 0)
    best_scores(MapSet.new([{0, 1}, {1, 0}]), scores, map)
  end

  def grow_map(map) do
    dim_x = 1 + (Map.keys(map) |> Enum.map(&elem(&1, 0)) |> Enum.max())
    dim_y = 1 + (Map.keys(map) |> Enum.map(&elem(&1, 1)) |> Enum.max())

    for i <- 0..4, j <- 0..4, {x, y} <- Map.keys(map), into: %{} do
      {{dim_x * i + x, dim_y * j + y}, rem(map[{x, y}] + i + j - 1, 9) + 1}
    end
  end
end
