defmodule Elixml.Namespace do
  @moduledoc """
    Alow to identifiy namespaces
  """

  def extract(data, ns_map \\ %{})

  def extract(%{name: name, children: children, attributes: attributes} = element, ns_map) do
    ns_map = _capture_definitions(ns_map, attributes)

    {namespace, name} = _split_prefixed(name, ns_map)
    
    element
    |> Map.put(:name, name)
    |> Map.put(:ns, namespace)
    |> Map.put(:children, extract(children, ns_map))
    |> Map.put(:attributes, _remove_definitions(attributes))
  end

  def extract(str, _) when is_binary(str), do: str
  def extract(list, ns_map) when is_list(list), do: Enum.map(list, &extract(&1, ns_map))


  def reverse(node, ns_map \\ %{})

  def reverse(%{name: name, attributes: attributes, children: children} = element, ns_map) do
    {name, attributes, ns_map} = case Map.get(element, :ns) do
      nil ->
        {name, attributes, ns_map}
      namespace ->
        {ns_map, shortcut, new_attributes} = get_namespace_shortcut(ns_map, namespace, attributes)
        {"#{shortcut}:#{name}", new_attributes, ns_map}
    end

    element
    |> Map.put(:name, name)
    |> Map.put(:attributes, attributes)
    |> Map.put(:children, reverse(children, ns_map))
    |> Map.delete(:ns)
  end
  def reverse(list, ns_map) when is_list(list) do
    list
    |> Enum.map(&reverse(&1, ns_map))
  end
  def reverse(data, _ns_map), do: data

  defp get_namespace_shortcut(ns_map, namespace, attributes) do
    Map.get(ns_map, namespace)
    |> case do
      nil ->
        shortcut = get_next_possible_ns_shortcut(ns_map)
        new_attributes = Map.put(attributes, "xmlns:#{shortcut}", namespace)
        {Map.put(ns_map, namespace, shortcut), shortcut, new_attributes}
      shortcut ->
        {ns_map, shortcut, attributes}
    end
  end

  defp get_next_possible_ns_shortcut(ns_map, idx \\ 1) do
    shortcut = "ns#{idx}"
    Map.get(ns_map, shortcut)
    |> case do
      nil -> shortcut
      _ -> get_next_possible_ns_shortcut(ns_map, idx+1)
    end
  end


  def _split_prefixed(prefixed, ns_map) do
    prefixed
    |> String.split(":")
    |> case do
      [ns, name] ->
        namespace = Map.get(ns_map, ns, nil)
        {namespace, name}
      [name] ->
        {nil, name}
    end
  end

  defp _capture_definitions(ns_map, attributes) do
    attributes
    |> Enum.reduce(ns_map, fn {k, v}, ns_map ->
      with ["xmlns", shortcut] <- String.split(k, ":") do
        ns_map    
        |> Map.put(shortcut, v)
      else
        _ -> ns_map
      end
    end)
  end

  def _remove_definitions(attributes) do
    attributes
    |> Enum.filter(fn {k, _v} ->
      !(k =~ ~r/^xmlns:.*$/)
    end)
    |> Enum.into(%{})
  end
end
