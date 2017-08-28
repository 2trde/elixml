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

lets say we have an file my_file.xml like

```xml
<root>
  <group_a id="1">
    <el1>a_1</el1>
    <el2>a_2</el2>
  </group_a>
  <group_b>
    <el1>b_1</el1>
    <el2>b_2</el2>
  </group_b>
  <group_c>
    <child1>
      <subchild>foo</subchild>
    </child1>
  </group_c>
</root>
```

we can load it

```elixir
mydoc =
  File.read!("my_file.xml")
  |> Elixml.parse

# will return the root element like
# %{name: "root", children: [...], attributes: [...]}
```

### Find elements

```
Elixml.find(mydoc, "//group_a")
# will return the list of elements found (only one)
```

### Access text

```
Elixml.find(mydoc, "//subchild") |> hd |> Elixml.text()
# will return "foo"
```

### Access attributes

```
Elixml.find(mydoc, "//group_a") |> hd |> Elixml.attribite("id")
# will return "1"
```

### Recunstruct

```elixir
child1 = Elixml.find(mydoc, "//child1") |> hd
Elixml.format_document(child1)
# will return
# """
#  <?xml version="1.0" encoding="UTF-8"?>
#  <child1>
#    <subchild>foo</subchild>
#  </child1>
# """
<Paste>
```



Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/elixml](https://hexdocs.pm/elixml).

