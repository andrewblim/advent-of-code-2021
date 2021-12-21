defmodule Day21 do
  def advance_pos(pos, rolls) do
    move =
      [rolls + 1, rolls + 2, rolls + 3]
      |> Enum.map(fn x -> rem(x - 1, 100) + 1 end)
      |> Enum.sum()

    new_pos = pos + move
    rem(new_pos - 1, 10) + 1
  end

  def play_turn({pos1, pos2}, {score1, score2}, turn, rolls) do
    {new_pos1, new_pos2} =
      if turn == 1 do
        {advance_pos(pos1, rolls), pos2}
      else
        {pos1, advance_pos(pos2, rolls)}
      end

    {new_score1, new_score2} =
      if turn == 1 do
        {score1 + new_pos1, score2}
      else
        {score1, score2 + new_pos2}
      end

    new_turn = if turn == 1, do: 2, else: 1
    new_rolls = rolls + 3
    {{new_pos1, new_pos2}, {new_score1, new_score2}, new_turn, new_rolls}
  end

  def play_traditional({pos1, pos2}, {score1, score2} \\ {0, 0}, turn \\ 1, rolls \\ 0) do
    cond do
      score1 >= 1000 or score2 >= 1000 ->
        IO.inspect({{pos1, pos2}, {score1, score2}, turn, rolls})
        score_game({pos1, pos2}, {score1, score2}, turn, rolls)

      true ->
        {{new_pos1, new_pos2}, {new_score1, new_score2}, new_turn, new_rolls} =
          play_turn({pos1, pos2}, {score1, score2}, turn, rolls)

        play_traditional({new_pos1, new_pos2}, {new_score1, new_score2}, new_turn, new_rolls)
    end
  end

  def score_game({_pos1, _pos2}, {score1, score2}, _turn, rolls) do
    losing_score = min(score1, score2)
    losing_score * rolls
  end

  def advance_pos_dirac(pos, move) do
    rem(pos + move - 1, 10) + 1
  end

  def play_dirac_turn({pos1, pos2}, {score1, score2}, turn, move) do
    {new_pos1, new_pos2} =
      if turn == 1 do
        {advance_pos_dirac(pos1, move), pos2}
      else
        {pos1, advance_pos_dirac(pos2, move)}
      end

    {new_score1, new_score2} =
      if turn == 1 do
        {score1 + new_pos1, score2}
      else
        {score1, score2 + new_pos2}
      end

    new_turn = if turn == 1, do: 2, else: 1
    {{new_pos1, new_pos2}, {new_score1, new_score2}, new_turn}
  end

  def play_dirac(states, {wins1, wins2}) do
    # states maps {{pos1, pos2}, {score1, score2}, turn} to count
    {new_states, {new_wins1, new_wins2}} =
      for {{{pos1, pos2}, {score1, score2}, turn}, count} <- states,
          move1 <- 1..3,
          move2 <- 1..3,
          move3 <- 1..3,
          reduce: {%{}, {wins1, wins2}} do
        {new_states, {new_wins1, new_wins2}} ->
          {{new_pos1, new_pos2}, {new_score1, new_score2}, new_turn} =
            play_dirac_turn({pos1, pos2}, {score1, score2}, turn, move1 + move2 + move3)

          {new_wins1, new_wins2, winner} =
            cond do
              new_score1 >= 21 ->
                {new_wins1 + count, new_wins2, true}

              new_score2 >= 21 ->
                {new_wins1, new_wins2 + count, true}

              true ->
                {new_wins1, new_wins2, false}
            end

          new_states =
            if winner do
              new_states
            else
              update = %{{{new_pos1, new_pos2}, {new_score1, new_score2}, new_turn} => count}
              Map.merge(new_states, update, fn _, v1, v2 -> v1 + v2 end)
            end

          # IO.inspect({new_states, {new_wins1, new_wins2}})
          {new_states, {new_wins1, new_wins2}}
      end

    if map_size(new_states) == 0 do
      {new_wins1, new_wins2}
    else
      play_dirac(new_states, {new_wins1, new_wins2})
    end
  end

  def play_dirac_init_pos({pos1, pos2}, {score1, score2} \\ {0, 0}, turn \\ 1) do
    play_dirac(
      %{{{pos1, pos2}, {score1, score2}, turn} => 1},
      {0, 0}
    )
  end
end
