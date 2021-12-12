defmodule Day12Test do
  use ExUnit.Case
  doctest Day12

  setup_all do
    input1 =
      Day12.parse_input("""
      start-A
      start-b
      A-c
      A-b
      b-d
      A-end
      b-end
      """)

    input2 =
      Day12.parse_input("""
      dc-end
      HN-start
      start-kj
      dc-start
      dc-HN
      LN-dc
      HN-end
      kj-sa
      kj-HN
      kj-dc
      """)

    input3 =
      Day12.parse_input("""
      fs-end
      he-DX
      fs-he
      start-DX
      pj-DX
      end-zg
      zg-sl
      zg-pj
      pj-he
      RW-he
      fs-DX
      pj-RW
      zg-RW
      start-pj
      he-WI
      zg-he
      pj-fs
      start-RW
      """)

    {:ok, %{input1: input1, input2: input2, input3: input3}}
  end

  test "ways_from", %{input1: input1, input2: input2, input3: input3} do
    assert Day12.ways_from(input1, "start") == 10
    assert Day12.ways_from(input2, "start") == 19
    assert Day12.ways_from(input3, "start") == 226
  end

  test "ways_from2", %{input1: input1, input2: input2, input3: input3} do
    assert Day12.ways_from2(input1, "start") == 36
    assert Day12.ways_from2(input2, "start") == 103
    assert Day12.ways_from2(input3, "start") == 3509
  end
end
