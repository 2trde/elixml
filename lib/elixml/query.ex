defmodule Elixml.Query do
  def find(%{name: name, children: children } = me, filter) do
    list = if (name == filter), do: [me], else: []
      ((children |> Enum.map(fn child -> find(child, filter) end)) ++ list)
      |> List.flatten
  end

  def find(_, filter), do: []
end
