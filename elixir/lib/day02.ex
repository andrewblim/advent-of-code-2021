defmodule Day02 do
  def read_input(file) do
    {:ok, file} = File.read(file)

    file
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn x ->
      [dir, n] = String.split(x, " ")
      {dir, String.to_integer(n)}
    end)
  end

  def move({direction, n}, {x, z}) do
    case direction do
      "forward" -> {x + n, z}
      "down" -> {x, z + n}
      "up" -> {x, z - n}
    end
  end

  def navigate(instructions, {x, z} \\ {0, 0}) do
    Enum.reduce(instructions, {x, z}, &move/2)
  end

  def move2({direction, n}, {x, z, aim}) do
    case direction do
      "forward" -> {x + n, z + n * aim, aim}
      "down" -> {x, z, aim + n}
      "up" -> {x, z, aim - n}
    end
  end

  def navigate2(instructions, {x, z, aim} \\ {0, 0, 0}) do
    Enum.reduce(instructions, {x, z, aim}, &move2/2)
  end
end
