defmodule Day18 do
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
    {x, []} = parse_expr(String.graphemes(line))
    x
  end

  def parse_expr(expr, parsed \\ []) do
    case expr do
      [] ->
        {List.first(parsed), []}

      ["[" | rest] ->
        {value, rest2} = parse_expr(rest)
        parse_expr(rest2, [value | parsed])

      ["]" | rest] ->
        [x, y] = parsed
        {{y, x}, rest}

      ["," | rest] ->
        parse_expr(rest, parsed)

      [digit | rest] ->
        parse_expr(rest, [String.to_integer(digit) | parsed])
    end
  end

  def add(x, y) do
    reduce({x, y})
  end

  def reduce(expr) do
    {expr1, %{}} = expr |> explode()

    if expr1 == expr do
      expr2 = expr1 |> split()

      if expr2 == expr do
        expr
      else
        reduce(expr2)
      end
    else
      reduce(expr1)
    end
  end

  def explode({l, r}, depth \\ 0) do
    # returns {value, shards}
    if depth >= 4 do
      {0, %{left: l, right: r}}
    else
      {{new_l, new_r}, shards} =
        case {l, r} do
          {{ll, lr}, _} ->
            {new_l, shards} = explode({ll, lr}, depth + 1)
            new_r = add_rightward_shard(r, Map.get(shards, :right, 0))
            {{new_l, new_r}, Map.delete(shards, :right)}

          _ ->
            {{l, r}, %{}}
        end

      if {new_l, new_r} != {l, r} do
        {{new_l, new_r}, shards}
      else
        case {l, r} do
          {_, {rl, rr}} ->
            {new_r, shards} = explode({rl, rr}, depth + 1)
            new_l = add_leftward_shard(l, Map.get(shards, :left, 0))
            {{new_l, new_r}, Map.delete(shards, :left)}

          _ ->
            {{l, r}, %{}}
        end
      end
    end
  end

  def add_rightward_shard(x, scalar) do
    case x do
      {l, r} ->
        {add_rightward_shard(l, scalar), r}

      _ ->
        x + scalar
    end
  end

  def add_leftward_shard(x, scalar) do
    case x do
      {l, r} ->
        {l, add_leftward_shard(r, scalar)}

      _ ->
        x + scalar
    end
  end

  def split({l, r}) do
    new_l =
      case l do
        {ll, lr} ->
          split({ll, lr})

        _ ->
          split_number(l)
      end

    if new_l != l do
      {new_l, r}
    else
      new_r =
        case r do
          {rl, rr} ->
            split({rl, rr})

          _ ->
            split_number(r)
        end

      {l, new_r}
    end
  end

  def split_number(x) do
    if x > 9 do
      {floor(x / 2), ceil(x / 2)}
    else
      x
    end
  end

  def magnitude(x) do
    case x do
      {l, r} -> 3 * magnitude(l) + 2 * magnitude(r)
      _ -> x
    end
  end

  def add_all(xs) do
    Enum.reduce(xs, fn x, acc -> add(acc, x) end)
  end

  def max_add_pairwise(xs) do
    pairs =
      for {x, ix} <- Enum.with_index(xs), {y, iy} <- Enum.with_index(xs), ix != iy do
        {x, y, magnitude(add(x, y))}
      end

    Enum.max_by(pairs, fn {_, _, mag} -> mag end)
  end
end
