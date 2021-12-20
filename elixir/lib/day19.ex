defmodule Day19 do
  def read_input(file) do
    {:ok, file} = File.read(file)
    parse_input(file)
  end

  def parse_input(raw_input) do
    raw_input
    |> String.trim()
    |> String.split("\n\n")
    |> Enum.reduce(%{}, fn x, acc -> Map.merge(parse_scanner_input(x), acc) end)
  end

  def parse_scanner_input(raw_input) do
    [scanner_line | coord_lines] = String.split(raw_input, "\n")

    [_, id] =
      Regex.run(
        ~r/--- scanner (\d+) ---/,
        scanner_line
      )

    coords =
      Enum.map(coord_lines, fn line ->
        [x, y, z] = String.split(line, ",") |> Enum.map(&String.to_integer/1)
        {x, y, z}
      end)

    %{String.to_integer(id) => MapSet.new(coords)}
  end

  def coord_add({x1, y1, z1}, {x2, y2, z2}) do
    {x1 + x2, y1 + y2, z1 + z2}
  end

  def coord_diff({x1, y1, z1}, {x2, y2, z2}) do
    {x1 - x2, y1 - y2, z1 - z2}
  end

  def mmult(
        {{x1, x2, x3}, {x4, x5, x6}, {x7, x8, x9}},
        {{y1, y2, y3}, {y4, y5, y6}, {y7, y8, y9}}
      ) do
    {
      {
        x1 * y1 + x2 * y4 + x3 * y7,
        x1 * y2 + x2 * y5 + x3 * y8,
        x1 * y3 + x2 * y6 + x3 * y9
      },
      {
        x4 * y1 + x5 * y4 + x6 * y7,
        x4 * y2 + x5 * y5 + x6 * y8,
        x4 * y3 + x5 * y6 + x6 * y9
      },
      {
        x7 * y1 + x8 * y4 + x9 * y7,
        x7 * y2 + x8 * y5 + x9 * y8,
        x7 * y3 + x8 * y6 + x9 * y9
      }
    }
  end

  def rotation_matrices() do
    identity = {{1, 0, 0}, {0, 1, 0}, {0, 0, 1}}
    rotate_x = {{1, 0, 0}, {0, 0, -1}, {0, 1, 0}}
    rotate_y = {{0, 0, -1}, {0, 1, 0}, {1, 0, 0}}
    rotate_z1 = {{0, -1, 0}, {1, 0, 0}, {0, 0, 1}}
    rotate_z2 = {{0, 1, 0}, {-1, 0, 0}, {0, 0, 1}}
    rotations_x = [identity | Enum.scan(0..2, identity, fn _, acc -> mmult(rotate_x, acc) end)]
    rotations_y = [identity | Enum.scan(0..2, identity, fn _, acc -> mmult(rotate_y, acc) end)]
    rotations_z = [rotate_z1, rotate_z2]

    for rot1 <- rotations_y ++ rotations_z, rot2 <- rotations_x do
      mmult(rot1, rot2)
    end
  end

  def rotate({{x1, x2, x3}, {x4, x5, x6}, {x7, x8, x9}}, {v1, v2, v3}) do
    {
      x1 * v1 + x2 * v2 + x3 * v3,
      x4 * v1 + x5 * v2 + x6 * v3,
      x7 * v1 + x8 * v2 + x9 * v3
    }
  end

  def overlap_generating_offsets(coords1, coords2, min_overlaps \\ 12) do
    # pick pairs from coords1 and every possible orientation of coords2
    # find the offset that would make these two pairs match
    # number of times an offset occurs = number of overlapping points
    offsets_and_orients =
      for rotation <- rotation_matrices(),
          coord1 <- coords1,
          coord2 <- coords2,
          rotated_coord2 = rotate(rotation, coord2) do
        offset = coord_diff(coord1, rotated_coord2)
        {offset, rotation}
      end

    freq = Enum.frequencies(offsets_and_orients)
    for {k, v} <- freq, v >= min_overlaps, into: [], do: k
  end

  def align_coords(coords, offset, rotation) do
    for coord <- coords, into: MapSet.new() do
      rotate(rotation, coord) |> coord_add(offset)
    end
  end

  def grow_map(scans, scanner_offsets, min_overlaps \\ 12) do
    cond do
      map_size(scans) == 1 ->
        {scans, scanner_offsets}

      # Map.values(scans) |> Enum.at(0)

      true ->
        pairs = for k1 <- Map.keys(scans), k2 <- Map.keys(scans), k2 > k1, do: {k1, k2}
        {k1, k2, offset, rotation} = find_overlapping_pairs(scans, pairs, min_overlaps)
        aligned = align_coords(scans[k2], offset, rotation)

        new_scans =
          Map.put(scans, k1, MapSet.union(scans[k1], aligned))
          |> Map.delete(k2)

        new_scanner_offsets = Map.put(scanner_offsets, {k1, k2}, offset)

        grow_map(new_scans, new_scanner_offsets, min_overlaps)
    end
  end

  def find_overlapping_pairs(scans, [{k1, k2} | rest], min_overlaps) do
    case overlap_generating_offsets(scans[k1], scans[k2], min_overlaps) do
      [{offset, rotation} | _] ->
        {k1, k2, offset, rotation}

      [] ->
        find_overlapping_pairs(scans, rest, min_overlaps)
    end
  end

  def beacons(scans, min_overlaps \\ 12) do
    {scans, _} = grow_map(scans, %{}, min_overlaps)
    scans |> Map.values() |> Enum.at(0) |> MapSet.to_list() |> Enum.sort()
  end

  def manhattan(coord1, coord2) do
    {x, y, z} = coord_diff(coord1, coord2)
    abs(x) + abs(y) + abs(z)
  end

  def max_manhattan(scans, min_overlaps \\ 12) do
    {_, scanners} = grow_map(scans, %{}, min_overlaps)

    distances =
      for v1 <- Map.values(scanners), v2 <- Map.values(scanners) do
        manhattan(v1, v2)
      end

    Enum.max(distances)
  end
end
