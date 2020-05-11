defmodule Elixml.ParserTest do
  use ExUnit.Case
  import Elixml.Parser
  import Elixml.Formatter

  test "parse simple doc" do
    sample = """
      <root bla="blub" foo="bar">
        <child1>bla</child1>
        <child2>blub</child2>
      </root>
    """

    assert format(parse(sample)) == String.trim(sample)
  end

  test "parse bigger_doc" do
    sample = File.read!("test/fixtures/soap_sample_1.xml")
    parse(sample)
    # I am happy it is not crashing :)
  end

  test "parse self-closing element" do
    sample = """
      <root bla="blub" foo="bar">
        <child1/>
      </root>
    """

    assert format(parse(sample)) == String.trim(sample)
  end
end
