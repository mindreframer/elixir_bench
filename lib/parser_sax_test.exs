defmodule ParserSaxTest do
  use ExUnit.Case

  describe "Parser" do
    test "works" do
      body = File.read!("fixtures/fixture2.xml")
      res = ParserSAX.run(body)
      res |> IO.inspect()
    end
  end
end
