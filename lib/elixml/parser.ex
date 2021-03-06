defmodule Elixml.Parser do
  import Elixml.Scanner

  def parse(buffer) do
    {root, _rem} = parse_root(buffer)
    root
  end

  defp parse_root(buffer) do
    scan(buffer)
    |> case do
      {{:text, _}, rem} ->
        parse_root(rem)
      {{:header, _}, rem} ->
        parse_root(rem)
      {{:element_open, _, _} = elem, rem} ->
        parse_element(elem, rem)
    end
  end

  defp parse_element({_, elem, attr_list}, buffer) do
    {children, rem} = parse_children(buffer, elem, [])
    {
      %{
        name: elem,
        attributes: attr_list |> Enum.into(%{}),
        children: Enum.reverse(children)
      },
      rem
    }
  end

  defp parse_element_no_children({_, elem, attr_list}, buffer) do
    {
      %{
        name: elem,
        attributes: attr_list |> Enum.into(%{}),
        children: []
      },
      buffer
    }
  end

  defp parse_children(buffer, current_element, list) do
    scan(buffer)
    |> case do
      {{:text, content}, rem} ->
        parse_children(rem, current_element, [content | list])
      {{:element_open, _, _} = elem, rem} ->
        {elem, rem} = parse_element(elem, rem)
        parse_children(rem, current_element, [elem | list])
      {{:element_open_close, _, _} = elem, rem} ->
        {elem, rem} = parse_element_no_children(elem, rem)
        parse_children(rem, current_element, [elem | list])
      {{:element_close, _current_element}, rem} ->
        {list, rem}
    end
  end
end
