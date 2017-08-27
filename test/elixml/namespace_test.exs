defmodule Elixml.NamespaceTest do
  use ExUnit.Case
  import Elixml.Namespace

  test "remove unknown ns in single node" do
    node = %{
      name: "ns1:root",
      children: [],
      attributes: %{}
    }
    extracted = extract(node)
    assert extracted.name == "root"
  end

  test "identifie namespace definition" do
    node = %{
      name: "ns1:root",
      children: [],
      attributes: %{"xmlns:ns1" => "http://foobar.com/something.xsd"}
    }
    extracted = extract(node)
    assert extracted.name == "root"
    assert extracted.ns == "http://foobar.com/something.xsd"
    assert extracted.attributes == %{}
  end

  describe "reerse" do
    test "putting prefixes back in" do
      node = %{
        name: "root",
        ns: "http://foobar.com/something.xsd",
        children: [],
        attributes: %{}
      }
      reversed = reverse(node)

      assert reversed == %{
        name: "ns1:root",
        attributes: %{"xmlns:ns1" => "http://foobar.com/something.xsd"},
        children: []
      }
    end
    test "handle different namespaces" do
      node = %{
        name: "root",
        ns: "http://foobar.com/something.xsd",
        children: [
          %{
            name: "root",
            ns: "http://foobar.com/something2.xsd",
            children: [
            ],
            attributes: %{}
          }
        ],
        attributes: %{}
      }
      reversed = reverse(node)

      assert reversed == %{
        name: "ns1:root",
        attributes: %{"xmlns:ns1" => "http://foobar.com/something.xsd"},
        children: [
          %{
            name: "ns2:root",
            attributes: %{"xmlns:ns2" => "http://foobar.com/something2.xsd"},
            children: []
          }
        ]
      }
    end
  end
end
