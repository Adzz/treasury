defmodule Treasury.StocksTest do
  use Treasury.DataCase
  alias Treasury.Stocks
  import Mox
  setup :verify_on_exit!

  describe "view_info/1" do
    test "queries for a stocks information" do
      assert Stocks.view_info("AAA") == 1
    end
  end
end
