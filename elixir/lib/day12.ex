defmodule Day12 do
  def read_input(file) do
    {:ok, file} = File.read(file)
    parse_input(file)
  end

  def parse_input(raw_input) do
    rows =
      raw_input
      |> String.trim()
      |> String.split("\n")

    for row <- rows, reduce: %{} do
      acc ->
        [x, y] = String.split(row, "-")

        acc
        |> Map.merge(%{x => [y]}, fn _, v1, v2 -> v1 ++ v2 end)
        |> Map.merge(%{y => [x]}, fn _, v1, v2 -> v1 ++ v2 end)
    end
  end

  def is_big?(x) do
    String.upcase(x) == x
  end

  def ways_from(map, x, visited) do
    case x do
      "end" ->
        [visited]

      _ ->
        for n <- map[x], is_big?(n) or not Enum.member?(visited, n), reduce: [] do
          acc -> acc ++ ways_from(map, n, [n | visited])
        end
    end
  end

  def ways_from(map, x) do
    ways_from(map, x, [x])
  end

  def visited_small_cave_twice?(visited) do
    small_visited = visited |> Enum.filter(fn x -> not is_big?(x) end)
    length(small_visited) != MapSet.size(MapSet.new(small_visited))
  end

  def ways_from2(map, x, visited) do
    case x do
      "end" ->
        [visited]

      _ ->
        small_eligible = not visited_small_cave_twice?(visited)

        for n <- map[x],
            n != "start",
            is_big?(n) or small_eligible or not Enum.member?(visited, n),
            reduce: [] do
          acc -> acc ++ ways_from2(map, n, [n | visited])
        end
    end
  end

  def ways_from2(map, x) do
    ways_from2(map, x, [x])
  end
end
