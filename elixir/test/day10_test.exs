defmodule Day10Test do
  use ExUnit.Case
  doctest Day10

  setup_all do
    input_str = """
    [({(<(())[]>[[{[]{<()<>>
    [(()[<>])]({[<{<<[]>>(
    {([(<{}[<>[]}>{[]{[(<()>
    (((({<>}<{<{<>}{[]{[]{}
    [[<[([]))<([[{}[[()]]]
    [{[{({}]{}}([{[{{{}}([]
    {<[[]]>}<{[{[{[]{()[[[]
    [<(<(<(<{}))><([]([]()
    <{([([[(<>()){}]>(<<{{
    <{([{{}}[<[[[<>{}]]]>[]]
    """

    input = input_str |> String.trim() |> String.split("\n") |> Enum.map(&String.graphemes/1)
    {:ok, %{input: input}}
  end

  test "grade_line" do
    assert Day10.grade_line(String.graphemes("{([(<{}[<>[]}>{[]{[(<()>")) == {:corrupt, 1197}
    assert Day10.grade_line(String.graphemes("[[<[([]))<([[{}[[()]]]")) == {:corrupt, 3}
    assert Day10.grade_line(String.graphemes("[{[{({}]{}}([{[{{{}}([]")) == {:corrupt, 57}
    assert Day10.grade_line(String.graphemes("[<(<(<(<{}))><([]([]()")) == {:corrupt, 3}
    assert Day10.grade_line(String.graphemes("<{([([[(<>()){}]>(<<{{")) == {:corrupt, 25137}

    assert Day10.grade_line(String.graphemes("[({(<(())[]>[[{[]{<()<>>")) ==
             {:incomplete, ["{", "{", "[", "[", "(", "{", "(", "["]}

    assert Day10.grade_line(String.graphemes("[(()[<>])]({[<{<<[]>>(")) ==
             {:incomplete, ["(", "{", "<", "[", "{", "("]}

    assert Day10.grade_line(String.graphemes("(((({<>}<{<{<>}{[]{[]{}")) ==
             {:incomplete, ["{", "{", "<", "{", "<", "(", "(", "(", "("]}

    assert Day10.grade_line(String.graphemes("{<[[]]>}<{[{[{[]{()[[[]")) ==
             {:incomplete, ["[", "[", "{", "{", "[", "{", "[", "{", "<"]}

    assert Day10.grade_line(String.graphemes("<{([{{}}[<[[[<>{}]]]>[]]")) ==
             {:incomplete, ["[", "(", "{", "<"]}
  end

  test "grade_all_corrupt_lines", %{input: input} do
    assert Day10.grade_all_corrupt_lines(input) == 26397
  end

  test "grades_of_all_non_corrupt_lines", %{input: input} do
    assert Day10.grades_of_all_non_corrupt_lines(input) |> Enum.sort() == [
             294,
             5566,
             288_957,
             995_444,
             1_480_781
           ]
  end

  test "median_grade_of_all_non_corrupt_lines", %{input: input} do
    assert Day10.median_grade_of_all_non_corrupt_lines(input) == 288_957
  end
end
