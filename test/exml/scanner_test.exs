defmodule Exml.ScannerTest do
  use ExUnit.Case
  import Exml.Scanner

  test "test super simple case" do
    assert {{:element_open, "bla", []}, ""}  == scan("<bla>")
  end

  test "test super simple case with ns" do
    assert {{:element_open, "ns1:bla", []}, ""}  == scan("<ns1:bla>")
  end

  test "scan attributes" do
    assert {{:element_open, "bla", [{"foo", "bar"}]}, ""}  == scan(~S{<bla foo="bar">})
  end

  test "scan text" do
    assert {{:text, "foobar"}, "</bla>"} = scan(~S{foobar</bla>})
  end

  test "scan close tag" do
    assert {{:element_close, "bla"}, ""}  == scan("</bla>")
  end
end
