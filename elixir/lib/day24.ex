defmodule Day24 do
  def read_input(file) do
    {:ok, file} = File.read(file)
    parse_input(file)
  end

  def parse_input(raw_input) do
    raw_input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.split/1)
  end

  def run_alu_cmd(cmd, input, state) do
    case cmd do
      ["inp", var] ->
        case input do
          [head | rest] ->
            {:ok, rest, %{state | var => head}}

          _ ->
            {:error, input, state}
        end

      ["add", var1, var2] ->
        val2 = state[var2] || String.to_integer(var2)
        {:ok, input, %{state | var1 => state[var1] + val2}}

      ["mul", var1, var2] ->
        val2 = state[var2] || String.to_integer(var2)
        {:ok, input, %{state | var1 => state[var1] * val2}}

      ["div", var1, var2] ->
        val2 = state[var2] || String.to_integer(var2)

        if val2 == 0 do
          {:error, input, state}
        else
          {:ok, input, %{state | var1 => Integer.floor_div(state[var1], val2)}}
        end

      ["mod", var1, var2] ->
        val2 = state[var2] || String.to_integer(var2)

        if state[var1] < 0 or val2 <= 0 do
          {:error, input, state}
        else
          {:ok, input, %{state | var1 => rem(state[var1], val2)}}
        end

      ["eql", var1, var2] ->
        val2 = state[var2] || String.to_integer(var2)
        {:ok, input, %{state | var1 => if(state[var1] == val2, do: 1, else: 0)}}
    end
  end

  def run_alu_cmds(cmds, input, state \\ %{"w" => 0, "x" => 0, "y" => 0, "z" => 0}) do
    case cmds do
      [cmd | rest_cmds] ->
        {status, new_input, new_state} = run_alu_cmd(cmd, input, state)

        if status == :error do
          {status, new_input, new_state}
        else
          run_alu_cmds(rest_cmds, new_input, new_state)
        end

      [] ->
        {:ok, input, state}
    end
  end

  def split_cmds(cmds, cur \\ [], splits \\ []) do
    case cmds do
      [["inp", var] | rest_cmds] ->
        if length(cur) == 0 do
          split_cmds(rest_cmds, [["inp", var]], splits)
        else
          split_cmds(rest_cmds, [["inp", var]], [cur | splits])
        end

      [cmd | rest_cmds] ->
        split_cmds(rest_cmds, [cmd | cur], splits)

      [] ->
        splits = [cur | splits]
        splits |> Enum.reverse() |> Enum.map(&Enum.reverse/1)
    end
  end

  def find_mod_to_i(cmds) do
    # correspond {input, previous z state up to mod 26} to whatever will produce
    # a new state with z = 0
    for i <- 1..9,
        z <- 0..25,
        {:ok, _, state} = run_alu_cmds(cmds, [i], %{"w" => 0, "x" => 0, "y" => 0, "z" => z}),
        state["z"] == 0,
        into: %{} do
      {z, i}
    end
  end

  def find_input_helper(
        cmds_list,
        range,
        input \\ [],
        state \\ %{"w" => 0, "x" => 0, "y" => 0, "z" => 0}
      ) do
    if length(input) < 3 do
      IO.inspect(input, charlists: :as_lists)
    end

    case cmds_list do
      [cmds | rest] ->
        mod_to_i = find_mod_to_i(cmds)

        cond do
          map_size(mod_to_i) == 0 ->
            for i <- range, reduce: nil do
              acc ->
                if acc do
                  acc
                else
                  {:ok, _, new_state} = run_alu_cmds(cmds, [i], state)
                  find_input_helper(rest, range, [i | input], new_state)
                end
            end

          Map.has_key?(mod_to_i, rem(state["z"], 26)) ->
            i = mod_to_i[rem(state["z"], 26)]
            {:ok, _, new_state} = run_alu_cmds(cmds, [i], state)
            find_input_helper(rest, range, [i | input], new_state)

          true ->
            nil
        end

      [] ->
        Enum.reverse(input)
    end
  end

  def find_largest_input(cmds) do
    cmds
    |> split_cmds()
    |> find_input_helper(9..1)
  end

  def find_smallest_input(cmds) do
    cmds
    |> split_cmds()
    |> find_input_helper(1..9)
  end
end
