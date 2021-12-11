defmodule Day11 do
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

  def step(grid) do
    grid = for pt <- Map.keys(grid), into: grid, do: {pt, grid[pt] + 1}
    grid = flash(grid, MapSet.new())
    n_flashes = Enum.count(Map.values(grid), fn pt -> pt > 9 end)
    grid = for pt <- Map.keys(grid), grid[pt] > 9, into: grid, do: {pt, 0}
    {grid, n_flashes}
  end

  def step(grid, n) do
    for _ <- 0..(n - 1), reduce: {grid, 0} do
      {old_grid, n_flashes} ->
        {new_grid, additional_flashes} = step(old_grid)
        {new_grid, n_flashes + additional_flashes}
    end
  end

  def step_until_all_flash(grid, i \\ 0) do
    {new_grid, additional_flashes} = step(grid)

    if additional_flashes == map_size(grid) do
      i + 1
    else
      step_until_all_flash(new_grid, i + 1)
    end
  end

  def flash(grid, already_flashed) do
    flashes =
      Map.keys(grid)
      |> Enum.filter(fn pt ->
        not MapSet.member?(already_flashed, pt) and grid[pt] > 9
      end)

    case flashes do
      [] ->
        grid

      _ ->
        new_grid =
          for {x, y} <- flashes,
              neighbor <- [
                {x - 1, y - 1},
                {x, y - 1},
                {x + 1, y - 1},
                {x - 1, y},
                {x, y},
                {x + 1, y},
                {x - 1, y + 1},
                {x, y + 1},
                {x + 1, y + 1}
              ],
              Map.has_key?(grid, neighbor),
              reduce: grid do
            acc -> Map.update!(acc, neighbor, fn v -> v + 1 end)
          end

        flash(new_grid, MapSet.union(already_flashed, MapSet.new(flashes)))
    end
  end

  def grid_to_str(grid) do
    {max_x, max_y} = Map.keys(grid) |> Enum.max()

    for x <- 0..max_x do
      for y <- 0..max_y do
        Integer.to_string(grid[{x, y}])
      end
      |> Enum.join("")
    end
    |> Enum.join("\n")
  end
end
