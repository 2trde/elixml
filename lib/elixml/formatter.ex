defmodule Elixml.Formatter do
  def format(element)
  def format(%{name: name, children: []} = element) do
    "<" <> name <> format_attributes(element[:attributes] || %{}) <> "/>"
  end
  def format(%{name: name, children: children} = element) do
    "<" <> name <> format_attributes(element[:attributes] || %{}) <> ">" <>
    format(children) <>
    "</" <> name <> ">"
  end

  def format(list) when is_list(list) do
    list
    |> Enum.map(fn el -> format(el) end)
    |> Enum.join("")
  end

  def format(text) when is_binary(text), do: escape_characters(text)


  def format_document(element) do
    root_node = format(element)
    "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n#{root_node}"
  end

  defp format_attributes(list) do
    (list
    |> Enum.map(fn
      {k, v} when is_binary(v) -> "#{k}=\"#{escape_characters(v)}\""
      {k, v} -> "#{k}=\"#{v}\""
    end)
    |> Enum.join(" "))
    |> case do
      "" -> ""
      str -> " " <> str
    end
  end

  defp escape_characters(text) do
    text
    |> String.replace("\"", "&quot;")
    |> String.replace("'", "&apos;")
    |> String.replace("<", "&lt;")
    |> String.replace(">", "&gt;")
    |> String.replace("&", "&amp;")
  end
end
