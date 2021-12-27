defmodule Day22 do
  def read_input(file) do
    {:ok, file} = File.read(file)
    parse_input(file)
  end

  def parse_input(raw_input) do
    raw_input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&parse_line/1)
  end

  def parse_line(line) do
    [_, on_off, x1, x2, y1, y2, z1, z2] =
      Regex.run(
        ~r/^(on|off) x=(-?\d+)\.\.(-?\d+),y=(-?\d+)\.\.(-?\d+),z=(-?\d+)\.\.(-?\d+)$/,
        line
      )

    {
      if(on_off == "on", do: :on, else: :off),
      {
        String.to_integer(x1),
        String.to_integer(x2),
        String.to_integer(y1),
        String.to_integer(y2),
        String.to_integer(z1),
        String.to_integer(z2)
      }
    }
  end

  def volume({x1, x2, y1, y2, z1, z2}) do
    # endpoints are inclusive
    (x2 - x1 + 1) * (y2 - y1 + 1) * (z2 - z1 + 1)
  end

  def intersect_cubic({ax1, ax2, ay1, ay2, az1, az2}, {bx1, bx2, by1, by2, bz1, bz2}) do
    x = intersect_linear({ax1, ax2}, {bx1, bx2})
    y = intersect_linear({ay1, ay2}, {by1, by2})
    z = intersect_linear({az1, az2}, {bz1, bz2})

    case {x, y, z} do
      {{x1, x2}, {y1, y2}, {z1, z2}} ->
        {x1, x2, y1, y2, z1, z2}

      _ ->
        nil
    end
  end

  def intersect_linear({ax1, ax2}, {bx1, bx2}) do
    cond do
      ax1 < bx1 and ax2 < bx1 ->
        nil

      ax1 < bx1 ->
        {bx1, min(ax2, bx2)}

      ax1 <= bx2 ->
        {ax1, min(ax2, bx2)}

      true ->
        nil
    end
  end

  def add_step({on_off, cube}, memo \\ []) do
    init_update = if on_off == :on, do: [{1, cube}], else: []

    update =
      for {count, memo_cube} <- memo,
          isect_cube = intersect_cubic(memo_cube, cube),
          isect_cube != nil do
        {-count, isect_cube}
      end

    init_update ++ update ++ memo
  end

  def add_steps(steps) do
    for step <- steps, reduce: [] do
      acc -> add_step(step, acc)
    end
  end

  def count_lit(steps, filter \\ nil) do
    memo = add_steps(steps)

    memo =
      if filter != nil do
        for {count, cube} <- memo,
            isect_cube = intersect_cubic(cube, filter),
            isect_cube != nil do
          {count, isect_cube}
        end
      else
        memo
      end

    for {count, cube} <- memo, reduce: 0 do
      acc -> acc + count * volume(cube)
    end
  end

  # def point_action({x, y, z}, {on_off, x1, x2, y1, y2, z1, z2}) do
  #   if x >= x1 and x <= x2 and y >= y1 and y <= y2 and z >= z1 and z <= z2 do
  #     on_off
  #   end
  # end

  # def point_after_steps({x, y, z}, steps) do
  #   for step <- steps, reduce: :off do
  #     state ->
  #       point_action({x, y, z}, step) || state
  #   end
  # end

  # def count_on(steps) do
  #   for x <- -50..50, y <- -50..50, z <- -50..50, reduce: 0 do
  #     total ->
  #       state = point_after_steps({x, y, z}, steps) || :off
  #       if state == :on, do: total + 1, else: total
  #   end
  # end
end
