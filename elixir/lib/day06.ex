defmodule Day06 do
  def read_input(file) do
    {:ok, file} = File.read(file)

    file
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> Enum.frequencies()
  end

  def advance_state(state, n) do
    cond do
      n == 0 ->
        state

      n > 0 ->
        new_state =
          Enum.reduce(Map.keys(state), %{}, fn k, acc ->
            Map.merge(acc, %{max(k - 1, Integer.mod(k - 1, 7)) => state[k]}, fn _, v1, v2 ->
              v1 + v2
            end)
          end)

        new_state = Map.merge(new_state, %{8 => Map.get(state, 0, 0)})
        advance_state(new_state, n - 1)
    end
  end

  def total_fish_after(state, n) do
    advance_state(state, n) |> Map.values() |> Enum.sum()
  end
end
