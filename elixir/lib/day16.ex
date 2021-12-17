defmodule Day16 do
  def read_input(file) do
    {:ok, file} = File.read(file)
    parse_input(file)
  end

  def parse_input(raw_input) do
    for ch <- String.graphemes(String.trim(raw_input)), into: <<>> do
      <<String.to_integer(ch, 16)::4>>
    end
  end

  def parse_packet(packet) do
    <<version::3, type::3, content::bits>> = packet

    {value, rest} =
      case type do
        4 -> parse_literal_content(content)
        _ -> parse_operator_content(content)
      end

    {%{version: version, type: type, value: value}, rest}
  end

  def parse_literal_content(content, value \\ 0) do
    <<head::1, x::4, rest::bits>> = content
    value = value * 16 + x

    if head == 0 do
      {value, rest}
    else
      parse_literal_content(rest, value)
    end
  end

  def parse_operator_content(content) do
    <<length_type::1, rest::bits>> = content

    if length_type == 0 do
      <<length::15, subpackets::size(length), rest2::bits>> = rest
      {parse_subpackets(<<subpackets::size(length)>>), rest2}
    else
      <<length::11, subpackets::bits>> = rest

      for _ <- 0..(length - 1), reduce: {[], subpackets} do
        {parsed, rest} ->
          {parsed_packet, rest2} = parse_packet(rest)
          {parsed ++ [parsed_packet], rest2}
      end
    end
  end

  def parse_subpackets(subpackets, parsed \\ []) do
    case subpackets do
      <<>> ->
        parsed

      _ ->
        {parsed_packet, rest} = parse_packet(subpackets)
        parse_subpackets(rest, parsed ++ [parsed_packet])
    end
  end

  def packet_version_sum(packet) do
    packet[:version] +
      if is_list(packet[:value]) do
        Enum.reduce(packet[:value], 0, fn x, acc -> packet_version_sum(x) + acc end)
      else
        0
      end
  end

  def parse_and_version_sum_packet(packet) do
    {parsed, _} = parse_packet(packet)
    packet_version_sum(parsed)
  end

  def packet_eval(packet) do
    case packet[:type] do
      0 ->
        Enum.map(packet[:value], &packet_eval/1) |> Enum.sum()

      1 ->
        Enum.map(packet[:value], &packet_eval/1) |> Enum.product()

      2 ->
        Enum.map(packet[:value], &packet_eval/1) |> Enum.min()

      3 ->
        Enum.map(packet[:value], &packet_eval/1) |> Enum.max()

      4 ->
        packet[:value]

      5 ->
        [x, y] = Enum.map(packet[:value], &packet_eval/1)
        if x > y, do: 1, else: 0

      6 ->
        [x, y] = Enum.map(packet[:value], &packet_eval/1)
        if x < y, do: 1, else: 0

      7 ->
        [x, y] = Enum.map(packet[:value], &packet_eval/1)
        if x == y, do: 1, else: 0
    end
  end

  def parse_and_eval_packet(packet) do
    {parsed, _} = parse_packet(packet)
    packet_eval(parsed)
  end
end
