defmodule Day07 do
  def read_input(file) do
    {:ok, file} = File.read(file)

    file
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  def median(input) do
    sorted = Enum.sort(input)
    Enum.at(sorted, floor(length(sorted) / 2))
  end

  def fuel_required(input) do
    med = median(input)
    {med, input |> Enum.map(fn x -> abs(x - med) end) |> Enum.sum()}
  end

  def penalty(x, y) do
    diff = abs(x - y)
    diff * (diff + 1)
  end

  def fuel_required2(input, guess, cur_penalty) do
    penalty_up = input |> Enum.map(fn x -> penalty(x, guess + 1) end) |> Enum.sum()
    penalty_dn = input |> Enum.map(fn x -> penalty(x, guess - 1) end) |> Enum.sum()

    cond do
      penalty_up < cur_penalty -> fuel_required2(input, guess + 1, penalty_up)
      penalty_dn < cur_penalty -> fuel_required2(input, guess + 1, penalty_dn)
      # since we want n(n+1)/2
      true -> {guess, round(cur_penalty / 2)}
    end
  end

  def fuel_required2(input) do
    init_guess = floor(Enum.sum(input) / length(input))
    init_penalty = input |> Enum.map(fn x -> penalty(x, init_guess) end) |> Enum.sum()
    fuel_required2(input, init_guess, init_penalty)
  end
end
