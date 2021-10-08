defmodule ElixirBenchTest do
  use ExUnit.Case
  doctest ElixirBench

  test "greets the world" do
    assert ElixirBench.hello() == :world
  end
end
