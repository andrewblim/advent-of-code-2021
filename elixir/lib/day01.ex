defmodule Day01 do
  def read_input(file) do
    {:ok, file} = File.read(file)
    file |> String.trim() |> String.split("\n") |> Enum.map(&String.to_integer/1)
  end

  def n_increases(depths) do
    {n, _} =
      depths
      |> Enum.reduce({0, nil}, fn
        x, {count, prev} when x > prev -> {count + 1, x}
        x, {count, _} -> {count, x}
      end)

    n
  end

  def n_increases(depths, window) do
    depths |> Enum.chunk_every(window, 1) |> Enum.map(&Enum.sum/1) |> n_increases()
  end
end
