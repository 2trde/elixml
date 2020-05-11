defmodule Elixml.FormatterTest do
  use ExUnit.Case
  import Elixml

  setup do
    sample = parse("""
      <ns1:root xmlns:ns1="http://foo.com/bar.xml">
        <ns1:foo>bar</ns1:foo>
      </ns1:root>
    """)
    %{sample: sample}
  end

  test "simple example", %{sample: sample} do
    assert String.trim(format(sample)) == String.trim("""
      <ns1:root xmlns:ns1="http://foo.com/bar.xml">
        <ns1:foo>bar</ns1:foo>
      </ns1:root>
    """)
  end
end
