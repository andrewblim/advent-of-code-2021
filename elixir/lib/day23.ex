defmodule Day23 do
  defmodule State do
    # for slots, 1 is the "deeper" position
    # hallway is just left-to-right
    # each can be :a, :b, :c, :d, or nil
    defstruct [
      :slota1,
      :slota2,
      :slotb1,
      :slotb2,
      :slotc1,
      :slotc2,
      :slotd1,
      :slotd2,
      :hall1,
      :hall2,
      :hall3,
      :hall4,
      :hall5,
      :hall6,
      :hall7
    ]
  end

  def cost_per_step(piece) do
    case piece do
      :a -> 1
      :b -> 10
      :c -> 100
      :d -> 1000
    end
  end

  def adjacencies() do
    # returns a map %{from => %{to => {path, steps}}}
    # where path is a set of all nodes that must be empty when moving from->to
    # and steps is the number of steps it takes to move from->to

    slota2_paths = [
      [:hall2, :hall1],
      [:hall2],
      [:hall3],
      [:hall3, :hall4],
      [:hall3, :hall4, :hall5],
      [:hall3, :hall4, :hall5, :hall6],
      [:hall3, :hall4, :hall5, :hall6, :hall7]
    ]

    slotb2_paths = [
      [:hall3, :hall2, :hall1],
      [:hall3, :hall2],
      [:hall3],
      [:hall4],
      [:hall4, :hall5],
      [:hall4, :hall5, :hall6],
      [:hall4, :hall5, :hall6, :hall7]
    ]

    slotc2_paths = [
      [:hall4, :hall3, :hall2, :hall1],
      [:hall4, :hall3, :hall2],
      [:hall4, :hall3],
      [:hall4],
      [:hall5],
      [:hall5, :hall6],
      [:hall5, :hall6, :hall7]
    ]

    slotd2_paths = [
      [:hall5, :hall4, :hall3, :hall2, :hall1],
      [:hall5, :hall4, :hall3, :hall2],
      [:hall5, :hall4, :hall3],
      [:hall5, :hall4],
      [:hall5],
      [:hall6],
      [:hall6, :hall7]
    ]

    slota1_paths = for path <- slota2_paths, do: [:slota2 | path]
    slotb1_paths = for path <- slotb2_paths, do: [:slotb2 | path]
    slotc1_paths = for path <- slotc2_paths, do: [:slotc2 | path]
    slotd1_paths = for path <- slotd2_paths, do: [:slotd2 | path]

    hall2_paths = [
      [:slota2],
      [:slota2, :slota1],
      [:hall3, :slotb2],
      [:hall3, :slotb2, :slotb1],
      [:hall3, :hall4, :slotc2],
      [:hall3, :hall4, :slotc2, :slotc1],
      [:hall3, :hall4, :hall5, :slotd2],
      [:hall3, :hall4, :hall5, :slotd2, :slotd1]
    ]

    hall3_paths = [
      [:slota2],
      [:slota2, :slota1],
      [:slotb2],
      [:slotb2, :slotb1],
      [:hall4, :slotc2],
      [:hall4, :slotc2, :slotc1],
      [:hall4, :hall5, :slotd2],
      [:hall4, :hall5, :slotd2, :slotd1]
    ]

    hall4_paths = [
      [:hall3, :slota2],
      [:hall3, :slota2, :slota1],
      [:slotb2],
      [:slotb2, :slotb1],
      [:slotc2],
      [:slotc2, :slotc1],
      [:hall5, :slotd2],
      [:hall5, :slotd2, :slotd1]
    ]

    hall5_paths = [
      [:hall4, :hall3, :slota2],
      [:hall4, :hall3, :slota2, :slota1],
      [:hall4, :slotb2],
      [:hall4, :slotb2, :slotb1],
      [:slotc2],
      [:slotc2, :slotc1],
      [:slotd2],
      [:slotd2, :slotd1]
    ]

    hall6_paths = [
      [:hall5, :hall4, :hall3, :slota2],
      [:hall5, :hall4, :hall3, :slota2, :slota1],
      [:hall5, :hall4, :slotb2],
      [:hall5, :hall4, :slotb2, :slotb1],
      [:hall5, :slotc2],
      [:hall5, :slotc2, :slotc1],
      [:slotd2],
      [:slotd2, :slotd1]
    ]

    hall1_paths = for path <- hall2_paths, do: [:hall2 | path]
    hall7_paths = for path <- hall6_paths, do: [:hall6 | path]

    %{
      slota1: paths_to_adjacencies(slota1_paths, :slota1),
      slota2: paths_to_adjacencies(slota2_paths, :slota2),
      slotb1: paths_to_adjacencies(slotb1_paths, :slotb1),
      slotb2: paths_to_adjacencies(slotb2_paths, :slotb2),
      slotc1: paths_to_adjacencies(slotc1_paths, :slotc1),
      slotc2: paths_to_adjacencies(slotc2_paths, :slotc2),
      slotd1: paths_to_adjacencies(slotd1_paths, :slotd1),
      slotd2: paths_to_adjacencies(slotd2_paths, :slotd2),
      hall1: paths_to_adjacencies(hall1_paths, :hall1),
      hall2: paths_to_adjacencies(hall2_paths, :hall2),
      hall3: paths_to_adjacencies(hall3_paths, :hall3),
      hall4: paths_to_adjacencies(hall4_paths, :hall4),
      hall5: paths_to_adjacencies(hall5_paths, :hall5),
      hall6: paths_to_adjacencies(hall6_paths, :hall6),
      hall7: paths_to_adjacencies(hall7_paths, :hall7)
    }
  end

  def is_slot(x) do
    x == :slota1 or x == :slota2 or x == :slotb1 or x == :slotb2 or x == :slotc1 or x == :slotc2 or
      x == :slotd1 or x == :slotd2
  end

  def is_hall(x) do
    not is_slot(x)
  end

  def paths_to_adjacencies(paths, from) do
    for path <- paths, into: %{} do
      {to, path_length} =
        for next <- path, reduce: {from, 0} do
          {prev, total} ->
            step_size =
              cond do
                is_slot(prev) and is_hall(next) -> 2
                is_slot(next) and is_hall(prev) -> 2
                prev == :hall1 or next == :hall1 -> 1
                prev == :hall7 or next == :hall7 -> 1
                is_hall(prev) and is_hall(next) -> 2
                true -> 1
              end

            {next, total + step_size}
        end

      {to, {MapSet.new(path), path_length}}
    end
  end

  def legal_next_states(state, cost, adjacencies) do
    for from <- Map.keys(state),
        from != :__struct__,
        piece = Map.get(state, from),
        piece != nil,
        to <- Map.keys(adjacencies[from]),
        {path, steps} = adjacencies[from][to],
        valid_move(piece, from, to, state),
        plausible_move(piece, from, to, state),
        path_empty(path, state) do
      {%{state | from => nil, to => piece}, cost + cost_per_step(piece) * steps}
    end
  end

  def path_empty(path, state) do
    Enum.all?(path, fn x -> Map.get(state, x) == nil end)
  end

  def valid_move(piece, from, to, state) do
    if is_hall(from) do
      case {piece, to} do
        {:a, :slota1} -> true
        {:a, :slota2} -> state.slota1 == :a
        {:b, :slotb1} -> true
        {:b, :slotb2} -> state.slotb1 == :b
        {:c, :slotc1} -> true
        {:c, :slotc2} -> state.slotc1 == :c
        {:d, :slotd1} -> true
        {:d, :slotd2} -> state.slotd1 == :d
        _ -> false
      end
    else
      true
    end
  end

  def plausible_move(piece, from, to, state) do
    case {piece, from, to} do
      {:a, :slota1, _} -> false
      {:a, :slota2, _} -> state.slota1 != :a
      {:b, :slotb1, _} -> false
      {:b, :slotb2, _} -> state.slotb1 != :b
      {:c, :slotc1, _} -> false
      {:c, :slotc2, _} -> state.slotc1 != :c
      {:d, :slotd1, _} -> false
      {:d, :slotd2, _} -> state.slotd1 != :d
      _ -> true
    end
  end

  def blocked_state(state) do
    # conditions where two pieces already in the hall block each other
    # no point in pursuing this route
    cond do
      state.hall3 == :c and state.hall4 == :a -> true
      state.hall3 == :d and state.hall4 == :a -> true
      state.hall3 == :d and state.hall5 == :a -> true
      state.hall4 == :d and state.hall5 == :a -> true
      state.hall4 == :d and state.hall5 == :b -> true
      true -> false
    end
  end

  def dijkstra(current, adjacencies, costs, visited) do
    case current do
      %State{
        slota1: :a,
        slota2: :a,
        slotb1: :b,
        slotb2: :b,
        slotc1: :c,
        slotc2: :c,
        slotd1: :d,
        slotd2: :d
      } ->
        {costs[current], MapSet.size(visited)}

      _ ->
        new_costs =
          for {next_state, next_cost} <- legal_next_states(current, costs[current], adjacencies),
              not MapSet.member?(visited, next_state),
              not blocked_state(next_state),
              reduce: costs do
            acc ->
              updated_cost = min(costs[next_state], next_cost)
              Map.put(acc, next_state, updated_cost)
          end

        new_visited = MapSet.put(visited, current)
        new_costs = Map.delete(new_costs, current)

        if rem(MapSet.size(new_visited), 10000) == 0 do
          IO.inspect(MapSet.size(new_visited))
        end

        if map_size(new_costs) == 0 do
          IO.inspect(current)
        end

        new_current = Map.keys(new_costs) |> Enum.min_by(fn x -> new_costs[x] end)
        dijkstra(new_current, adjacencies, new_costs, new_visited)
    end
  end

  def dijkstra(state) do
    dijkstra(state, adjacencies(), %{state => 0}, MapSet.new())
  end

  # should be 46
  # Day23.dijkstra(%Day23.State{slota1: :a, slota2: :b, slotb1: :b, slotb2: :a, slotc1: :c, slotc2: :c, slotd1: :d, slotd2: :d})

  # should be 12521
  # Day23.dijkstra(%Day23.State{slota1: :a, slota2: :b, slotb1: :d, slotb2: :c, slotc1: :c, slotc2: :b, slotd1: :a, slotd2: :d})
end
