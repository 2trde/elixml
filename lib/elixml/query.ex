defmodule Elixml.Query do

  @doc """
    find nodes
  """
  def find(data, xpath) when is_binary(xpath) do
    chain = xpath
            |> String.replace("//", "/*/")
            |> String.split("/", trim: true)
    find(data, chain)
  end
  def find(%{name: _name, children: children } = me, filter) do
    {list, filter} = process_filter_chain(me, filter)

    child_hits = if filter do
                   children
                   |> Enum.map(fn child -> find(child, filter) end)
                 else 
                   []
                 end

    (list ++ child_hits)
    |> List.flatten
  end
  def find(_, _filter), do: []


  defp process_filter_chain(el, filter)
  defp process_filter_chain(_el, []), do: {[], nil}
  defp process_filter_chain(el, [last]) do
    if does_match?(el, last) do
      {[el], nil}
    else
      {[], nil}
    end
  end
  defp process_filter_chain(el, ["*", first] = filter) do
    if does_match?(el, first) do
      {[el], nil}
    else
      {[], filter}
    end
  end
  defp process_filter_chain(el, ["*", first | rem] = filter) do
    if does_match?(el, first) do
      {[], rem}
    else
      {[], filter}
    end
  end
  defp process_filter_chain(el, [first | rem]) do
    if does_match?(el, first) do
      {[], rem}
    else
      {[], nil}
    end
  end


  # @doc """
  #   check if a filter matches a node
  # """
  defp does_match?(element, filter)
  defp does_match?(%{name: name}, name), do: true
  defp does_match?(_, _), do: false


  @doc """
    extract all the text content from an element and its children
  """
  def text(list) when is_list(list) do
    list
    |> Enum.map(&text/1)
    |> Enum.join
  end
  def text(bin) when is_binary(bin), do: bin
  def text(%{children: children}) do
    text(children)
  end

  def attribute(%{attributes: attributes}, name) do
    Map.get(attributes, name)
  end

end
