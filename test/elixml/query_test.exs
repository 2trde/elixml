defmodule Elixml.QueryTest do
  use ExUnit.Case
  import Elixml

  test "simple find in big doc" do
    sample = File.read!("test/fixtures/soap_sample_1.xml")
    doc = parse(sample)
    IO.inspect find(doc, "ns1:BaseModelName")
  end
end
