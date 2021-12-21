defmodule Day20 do
  def read_input(file) do
    {:ok, file} = File.read(file)
    parse_input(file)
  end

  def parse_input(raw_input) do
    [algo_input, image_input] =
      raw_input
      |> String.trim()
      |> String.split("\n\n")

    {parse_algo_input(algo_input), parse_image_input(image_input)}
  end

  def parse_algo_input(raw_input) do
    for {ch, i} <- Enum.with_index(String.graphemes(raw_input)), into: %{} do
      {i, ch}
    end
  end

  def parse_image_input(raw_input) do
    for {line, row} <- Enum.with_index(String.split(raw_input, "\n")),
        {ch, col} <- Enum.with_index(String.graphemes(line)),
        into: %{} do
      {{row, col}, ch}
    end
  end

  def grow_image(image, off_image, algo) do
    new_image =
      for {image_x, image_y} <- Map.keys(image),
          x_offset <- [-1, 0, 1],
          y_offset <- [-1, 0, 1],
          x = image_x + x_offset,
          y = image_y + y_offset,
          uniq: true,
          into: %{} do
        neighbors =
          for x_offset2 <- [-1, 0, 1], y_offset2 <- [-1, 0, 1] do
            {x + x_offset2, y + y_offset2}
          end

        index =
          for n <- neighbors, reduce: 0 do
            total ->
              value =
                case Map.get(image, n, off_image) do
                  "." -> 0
                  "#" -> 1
                end

              2 * total + value
          end

        {{x, y}, Map.get(algo, index, nil)}
      end

    new_image = for {k, v} <- new_image, v != nil, into: %{}, do: {k, v}

    new_off_image_index =
      case off_image do
        "." -> 0
        "#" -> 511
      end

    {new_image, algo[new_off_image_index]}
  end

  def step_image(image, off_image, algo, n) do
    IO.inspect(n)

    cond do
      n > 0 ->
        {new_image, new_off_image} = grow_image(image, off_image, algo)
        step_image(new_image, new_off_image, algo, n - 1)

      true ->
        {image, off_image}
    end
  end

  def count_lit_pixels(image) do
    Map.values(image) |> Enum.count(fn x -> x == "#" end)
  end

  def print_image(image) do
    {x_min, y_min} = Map.keys(image) |> Enum.min()
    {x_max, y_max} = Map.keys(image) |> Enum.max()

    for x <- x_min..x_max do
      for y <- y_min..y_max do
        IO.write(image[{x, y}])
      end

      IO.write("\n")
    end

    nil
  end
end
