defmodule Elixml.QueryTest do
  use ExUnit.Case
  import Elixml

  setup do
    sample = parse("""
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
    """)
    %{sample: sample}
  end

  describe "find" do

    test "simple query", %{sample: sample} do
      [el] = find(sample, "root/group_a")
      assert attribute(el, "id") == "1"
    end

    test "double slash", %{sample: sample} do
      [el] = find(sample, "//group_a")
      assert attribute(el, "id") == "1"
    end

    test "double slash, more complex", %{sample: sample} do
      [el] = find(sample, "//group_c/child1/subchild")
      assert text(el) == "foo"
    end

    test "double slash in the middle", %{sample: sample} do
      [el] = find(sample, "/root//subchild")
      assert text(el) == "foo"
    end
  end

  describe "text" do
    test "format a single node" do
      node = %{
        name: "foo",
        children: [
          "Text content"
        ]
      }

      assert text(node) == "Text content"
    end

    test "format a node tree" do
      node = %{
        name: "foo",
        children: [
          "Text content",
          %{name: "bar", children: [
            " more text" 
          ]}
        ]
      }

      assert text(node) == "Text content more text"
    end
  end
end
