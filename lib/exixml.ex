defmodule Elixml do
  @doc """
    parse xml text

    example:

      File.read!("my.xml")
      |> Elixml.parse

  """
  def parse(text) do
    Elixml.Parser.parse(text)
    |> Elixml.Namespace.extract()
  end

  @doc """
    format an xml node as text

    %> format(%{name: mynode, children: [], attributes: %{"foo" => "bar"})
    <mynode foo="bar">

  """
  def format(data) do
    data
    |> Elixml.Namespace.reverse()
    |> Elixml.Formater.format()
  end

  @doc """
    format an xml node as xml document text

    %> format(%{name: mynode, children: [], attributes: %{"foo" => "bar"})
    <?xml version="1.0" encoding="UTF-8"?>
    <mynode foo="bar">

  """
  def format_document(data), do: Elixml.Formater.format_document(data)


  @doc """
    find elements by name
  """
  def find(data, filter), do: Elixml.Query.find(data, filter)


  @doc """
    get textual content from a node
  """
  def text(data), do: Elixml.Query.text(data)
  def attribute(data, name), do: Elixml.Query.attribute(data, name)
end
