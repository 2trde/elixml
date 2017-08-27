# Elixml

Elixml is going to be an xml lib for Elixir that is
easy to and enable you to

- parse xml files (kinda works)
- query xml
 - super basic implementation of searching
 - xpath (not started)
- namespace support (not implemented)
- export to file/text (basic impl works)
- compose documents
  - possible with using maps
  - dsl would be nice (not implemented)
  
## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `elixml` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:elixml, github: "mlankenau/elixml"}
  ]
end
```

## Usage

### Parse an XML file

```elixir
mydoc =
  File.read!("my_file.xml")
  |> Elixml.parse

# will return the root element like
# %{name: "my_root_element", children: [...], attributes: [...]}
```

### Find elements

```
Elixml.find(mydoc, "some_element")

# will return the list of elements found

```


Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/elixml](https://hexdocs.pm/elixml).

