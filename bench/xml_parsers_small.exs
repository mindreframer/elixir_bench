big_body = File.read!("fixtures/fixture1.xml")
defmodule Parser1 do
  import SweetXml
  def run(body) do
    body
    |> parse(dtd: :none)
  end
end

defmodule Parser2 do
  def run(body) do
    SAXMap.from_string(body, ignore_attribute: {false, "@"})
  end
end

defmodule Parser3 do
  def run(body) do
    Saxy.SimpleForm.parse_string(body)
  end
end

Benchee.run(
  %{
    "ParserSweet" => fn ->
      ParserSweet.run(big_body)
    end,
    "ParserSAX" => fn ->
      ParserSAX.run(big_body)
    end,
    "Parser1 - SweetXml" => fn ->
      Parser1.run(big_body)
    end,
    "Parser2 - SAXMap" => fn ->
      Parser2.run(big_body)
    end,
    "Parser3 - Saxy.SimpleForm" => fn ->
      Parser3.run(big_body)
    end
  }
)
