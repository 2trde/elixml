defmodule Elixml.Scanner do
  @whitespaces '\t\r\n '
  @identifier_chars 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ01234567890_:'

  @doc """
    scan a buffer

    will return an tuple like
      {:element, %{"foo" => "bar"}}
      {:text, "foo bar foo"}
  """
  def scan(buffer)
  def scan("") do
    {:eof, ""}
  end
  def scan("</" <> rem) do
    rem = _eat_ws(rem)
    {name, rem} = _scan_identifier(rem)
    rem = _eat_ws(rem)
    rem = _expect(rem, ?>)
    {{:element_close, name}, rem}
  end
  def scan("<?xml" <> rem) do
    rem = _eat_ws(rem)
    {attr_list, rem} = _scan_attributes(rem, [])
    rem = _eat_ws(rem)
    rem = _expect(rem, ??)
    rem = _expect(rem, ?>)
    {{:header, attr_list}, rem}
  end
  def scan("<![CDATA[" <> rem) do
    {text, rem} = _scan_cdata(rem, "")
    {{:text, text}, rem}
  end
  def scan("<" <> rem) do
    rem = _eat_ws(rem)
    {name, rem} = _scan_identifier(rem)
    rem = _eat_ws(rem)
    {attr_list, rem} = _scan_attributes(rem, [])
    _scan_element_ending(rem, name, attr_list)
  end
  def scan(rem) do
    _scan_text(rem, "")
  end

  defp _scan_cdata("]]>" <> rem, buffer) do
    {buffer, rem}
  end
  defp _scan_cdata(data, buffer) do
    {c, rem} = String.next_codepoint(data)
    _scan_cdata(rem, buffer <> c)
  end

  defp _scan_text("", buffer) do
    {{:text, buffer}, ""}
  end
  defp _scan_text("<" <> _ = rem, buffer) do
    {{:text, buffer}, rem}
  end
  defp _scan_text(data, buffer) do
    {c, rem} = String.next_codepoint(data)
    _scan_text(rem, buffer <> c)
  end


  defp _scan_element_ending(">" <> rem, name, attr_list) do
    {{:element_open, name, attr_list}, rem}
  end
  defp _scan_element_ending("/>" <> rem, name, attr_list) do
    {{:element_open_close, name, attr_list}, rem}
  end

  ### scan attributes ##################################

  defp _scan_attributes(">" <> _ = rem, attr_list) do
    {attr_list, rem}
  end
  defp _scan_attributes("/>" <> _ = rem, attr_list) do
    {attr_list, rem}
  end
  defp _scan_attributes("?>" <> _ = rem, attr_list) do
    {attr_list, rem}
  end
  defp _scan_attributes(rem, attr_list) do
    {name, rem} = _scan_identifier(rem)
    rem = _eat_ws(rem)
    rem = _expect(rem, ?=)
    rem = _eat_ws(rem)
    {value, rem} = _scan_quoted(rem)
    rem = _eat_ws(rem)
    _scan_attributes(rem, [{name, value} | attr_list])
  end

  ### scan quote #######################################

  defp _scan_quoted("\"" <> rem) do
    _scan_quoted_active(rem, "")
  end
  defp _scan_quoted_active("\"" <> rem, value) do
    {value, rem}
  end
  defp _scan_quoted_active(data, value) do
    {c, rem} = String.next_codepoint(data)
    _scan_quoted_active(rem, value <> c)
  end

  ### expect a special char ############################

  defp _expect(<< exp :: utf8, rem :: binary >>, exp) do
    rem
  end

  ### eat whitespaces #################################

  defp _eat_ws(<< ws :: utf8, rem :: binary >>)  when ws in @whitespaces do
    _eat_ws(rem)
  end
  defp _eat_ws(rem) do
    rem
  end

  ### scan identifier ################################

  defp _scan_identifier(<< ws :: utf8, rem :: binary>>) when ws in @whitespaces do
    _scan_identifier(rem)
  end
  defp _scan_identifier(rem) do
    _scan_identifier_active(rem, "")
  end
  defp _scan_identifier_active(<< c :: utf8, rem :: binary>>, id) when c in @identifier_chars do
    _scan_identifier_active(rem, id <> << c >>)
  end
  defp _scan_identifier_active(rem, id) do
    {id, rem}
  end
end
