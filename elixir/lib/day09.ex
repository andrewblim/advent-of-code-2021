defmodule Day09 do
  def read_input(file) do
    {:ok, file} = File.read(file)

    raw_input =
      file
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(fn row -> String.graphemes(row) |> Enum.map(&String.to_integer/1) end)

    for {row, i} <- Enum.with_index(raw_input), {x, j} <- Enum.with_index(row), into: %{} do
      {{i, j}, x}
    end
  end

  def is_low_point?(heightmap, {x, y}) do
    # relies on number < nil being true
    neighbors = [{x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}]
    Enum.all?(neighbors, fn n -> heightmap[{x, y}] < heightmap[n] end)
  end

  def find_low_points(heightmap) do
    {max_x, max_y} = Map.keys(heightmap) |> Enum.max()
    for x <- 0..max_x, y <- 0..max_y, is_low_point?(heightmap, {x, y}), do: {x, y}
  end

  def risk_level(heightmap, {x, y}) do
    heightmap[{x, y}] + 1
  end

  def risk_low_points(heightmap) do
    low_points = find_low_points(heightmap)

    Enum.map(low_points, fn {x, y} -> risk_level(heightmap, {x, y}) end)
    |> Enum.sum()
  end

  def basin(heightmap, {x, y}, cur_basin) do
    cur_basin = MapSet.put(cur_basin, {x, y})

    neighbors =
      Enum.filter(
        [{x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}],
        fn n -> heightmap[n] != 9 and heightmap[n] != nil and not MapSet.member?(cur_basin, n) end
      )

    Enum.reduce(neighbors, cur_basin, fn n, acc ->
      MapSet.union(basin(heightmap, n, acc), acc)
    end)

    # for n <- neighbors,
    #     heightmap[n] != 9,
    #     heightmap[n] != nil,
    #     not MapSet.member?(cur_basin, n) do
    #   cur_basin = MapSet.put(cur_basin, n)
    #   basin(heightmap, n, cur_basin)
    # end
    # cur_basin
  end

  def basin(heightmap, {x, y}) do
    basin(heightmap, {x, y}, MapSet.new())
  end

  def basin_sizes(heightmap) do
    low_points = find_low_points(heightmap)
    Enum.map(low_points, fn pt -> basin(heightmap, pt) |> MapSet.size() end)
  end

  def top_basin_sizes(heightmap, n) do
    basin_sizes(heightmap) |> Enum.sort() |> Enum.reverse() |> Enum.take(n) |> Enum.product()
  end
end
