body = File.read!("fixtures/fixture2.xml")

defmodule Parser do
  def parse(body) do
    SAXMap.from_string(body, ignore_attribute: {false, "@"})
  end
end

{:ok, json} = Parser.parse(body)


defmodule Path0 do
  def run(map) do
    map |> Map.get("search:search-result") |> Map.get("content") |> Map.get("search:total") |> Map.get("content")
  end
end

defmodule Path1 do
  # https://github.com/wapitea/telepath
  # does not support colons in keys:
  # Telepath.get(%{"string_key:key" => "value"}, ~t/string_key:key/)
  import Telepath
  def run(map) do
    Telepath.get(map, ~t/search:search-result.content.search:total.content/)
  end
end

defmodule Path2 do
  require Pathex
  import Pathex
  # https://github.com/hissssst/pathex
  def run(map) do
    path = ~P[search:search-result/content/search:total/content]json
    view map, path
  end
end

defmodule Path3 do
  def run(map) do
    # Warpath.query(map, "$.search:search-result.content.search:total.content")
    ## cant target elems with colon (":") in keys
  end
  # https://github.com/cleidiano/warpath
end

defmodule Path4 do
  # https://github.com/ispirata/exjsonpath
  # also issues
end

defmodule Path5 do
  # https://github.com/mtannaan/elixpath
  def run(map) do
    path = "search:search-result.content.search:total.content"
    Elixpath.get!(map, path)
  end
end

Benchee.run(
  %{
    "0 - map get" => fn ->
      Path0.run(json)
    end,
    "2 - hissssst/pathex" => fn ->
      Path2.run(json)
    end,
    # "3 - cleidiano/warpath" => fn ->
    #   Path3
    # end,
    # "4 - ispirata/exjsonpath" => fn ->
    #   Path4
    # end,
    "5 - mtannaan/elixpath" => fn ->
      Path5.run(json)
    end
  }
)
