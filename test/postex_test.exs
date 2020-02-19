defmodule PostexTest do
  use ExUnit.Case
  doctest Postex

  test "greets the world" do
    assert Postex.hello() == :world
  end
end
