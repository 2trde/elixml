defmodule Elixml do
  @doc """
  parse xml text

  example:

    File.read!("my.xml")
    |> Elixml.parse

  iex> Elixml.parse("<root><ns1:child xmlns:ns1=\\"https://example.com/ns.xsd\\">content</ns1:child></root>")
  %{name: "root", ns: nil, attributes: %{}, children: [
    %{name: "child", ns: "https://example.com/ns.xsd", attributes: %{}, children: ["content"]}
  ]}
  """
  def parse(text) do
    Elixml.Parser.parse(text)
    |> Elixml.Namespace.extract()
  end

  @doc """
    format an xml node as text

    iex> Elixml.format(%{name: "mynode", children: [], attributes: %{"foo" => "bar"}})
    "<mynode foo=\\"bar\\"></mynode>"

  """
  def format(data) do
    data
    |> Elixml.Namespace.reverse()
    |> Elixml.Formater.format()
  end

  @doc """
    format an xml node as xml document text

    iex> Elixml.format_document(%{name: "mynode", ns: nil, children: [], attributes: %{"foo" => "bar"}})
    "<?xml version=\\"1.0\\" encoding=\\"UTF-8\\"?>\\n<mynode foo=\\"bar\\"></mynode>"

  """
  def format_document(data) do
    data
    |> Elixml.Namespace.reverse()
    |> Elixml.Formater.format_document()
  end


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
