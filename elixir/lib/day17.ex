defmodule Day17 do
  def read_input(file) do
    {:ok, file} = File.read(file)
    parse_input(file)
  end

  def parse_input(raw_input) do
    [_, x1, x2, y1, y2] =
      Regex.run(
        ~r/^target area\: x=([-\d]+)..([-\d]+), y=([-\d]+)..([-\d]+)/,
        raw_input
      )

    {
      String.to_integer(x1),
      String.to_integer(x2),
      String.to_integer(y1),
      String.to_integer(y2)
    }
  end

  def trajectory({x_velo, y_velo}, {x1, x2, y1, y2}, path \\ [{0, 0}]) do
    [{x, y} | _] = path

    cond do
      x >= x1 and x <= x2 and y >= y1 and y <= y2 ->
        {true, path}

      x > x2 or (y < y1 and y_velo <= 0) ->
        {false, path}

      true ->
        trajectory(
          {max(x_velo - 1, 0), y_velo - 1},
          {x1, x2, y1, y2},
          [{x + x_velo, y + y_velo} | path]
        )
    end
  end

  def hits({x1, x2, y1, y2}) do
    # horrible bounds, do better
    min_y_guess = min(y1, 0)
    max_y_guess = max(x2, y2)

    for init_x_velo <- 0..x2//1, init_y_velo <- min_y_guess..max_y_guess//1, reduce: [] do
      acc ->
        case trajectory({init_x_velo, init_y_velo}, {x1, x2, y1, y2}) do
          {true, path} ->
            [{init_x_velo, init_y_velo, path} | acc]

          _ ->
            acc
        end
    end
  end

  def peak_y({x1, x2, y1, y2}) do
    valids = hits({x1, x2, y1, y2})

    peaks =
      valids
      |> Enum.map(fn {init_x_velo, init_y_velo, path} ->
        {init_x_velo, init_y_velo, Enum.map(path, fn {_, y} -> y end) |> Enum.max()}
      end)

    peaks |> Enum.map(fn {_, _, max_y} -> max_y end) |> Enum.max()
  end
end
