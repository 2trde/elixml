defmodule Exml.Scanner do
  @whitespaces '\t\r\n '
  @identifier_chars 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ01234567890_:'

  @doc """
    scan a buffer

    will return an tuple like
      {:element, %{"foo" => "bar"}}
      {:text, "foo bar foo"}
  """
  def scan(buffer) 
  def scan("</" <> rem) do
    rem = _eat_ws(rem)
    {name, rem} = _scan_identifier(rem)
    rem = _eat_ws(rem)
    rem = _expect(rem, ?>)
    {{:element_close, name}, rem}
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


  def _scan_text("<" <> _ = rem, buffer) do
    {{:text, buffer}, rem} 
  end
  def _scan_text(<< c :: utf8, rem :: binary>>, buffer) do
    _scan_text(rem, buffer <> << c >>)
  end


  def _scan_element_ending(">" <> rem, name, attr_list) do
    {{:element_open, name, attr_list}, rem}
  end
  def _scan_element_ending("/>" <> rem, name, attr_list) do
    {{:element_open_close, name, attr_list}, rem}
  end

  def _scan_attributes(">" <> _ = rem, attr_list) do
    {attr_list, rem}
  end
  def _scan_attributes("/>" <> _ = rem, attr_list) do
    {attr_list, rem}
  end
  def _scan_attributes(rem, attr_list) do
    {name, rem} = _scan_identifier(rem)
    rem = _eat_ws(rem)
    rem = _expect(rem, ?=)
    rem = _eat_ws(rem)
    {value, rem} = _scan_quoted(rem)
    rem = _eat_ws(rem)
    _scan_attributes(rem, [{name, value} | attr_list])
  end

  def _scan_quoted("\"" <> rem) do
    _scan_quoted_active(rem, "")
  end
  def _scan_quoted_active("\"" <> rem, value) do
    {value, rem}
  end
  def _scan_quoted_active(<< c :: utf8, rem :: binary>>, value) do
    _scan_quoted_active(rem, value <> << c >>)
  end

  def _expect(<< exp :: utf8, rem :: binary >>, exp) do
    rem
  end


  def _eat_ws(<< ws :: utf8, rem :: binary >>)  when ws in @whitespaces do
    _eat_ws(rem)
  end
  def _eat_ws(rem) do
    rem
  end


  def _scan_identifier(<< ws :: utf8, rem :: binary>>) when ws in @whitespaces do
    _scan_identifier(rem)
  end
  def _scan_identifier(rem) do
    _scan_identifier_active(rem, "")
  end
  def _scan_identifier_active(<< c :: utf8, rem :: binary>>, id) when c in @identifier_chars do
    _scan_identifier_active(rem, id <> << c >>)
  end
  def _scan_identifier_active(rem, id) do
    {id, rem}
  end
end
