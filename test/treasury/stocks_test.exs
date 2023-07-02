defmodule Treasury.StocksTest do
  use Treasury.DataCase
  alias Treasury.Stocks
  import Mox
  setup :verify_on_exit!

  describe "view_info/1" do
    test "queries for a stocks information" do
      Mox.expect(Treasury.HttpMock, :get, fn request ->
        assert request == %{
                 headers: [
                   {"Authorization", "Bearer cL7FTRzqSfY8CpZXYJ53q2rpV4W5ybvddqObYiODJzc"}
                 ],
                 url: "https://treasury.app/api/v1/hiring/symbols/AAA"
               }

        fixture =
          "{\"expense_ratio_basis_points\":null,\"name\":\"Apple Inc\",\"price\":193.97,\"symbol\":\"AAPL\"}"

        {:ok, %{body: fixture, status_code: 200}}
      end)

      Mox.expect(Treasury.DateTimeMock, :utc_now, fn ->
        ~U[2023-07-02 03:34:22.755919Z]
      end)

      assert Stocks.view_info("AAA") ==
               {:ok,
                %Treasury.StockInformation{
                  name: "Apple Inc",
                  price: Decimal.new("193.97"),
                  symbol: "AAPL",
                  expense_ratio_basis_points: nil,
                  refreshed_on: "2 July 2023 @ 03:34"
                }}
    end

    test "a 500 is an error" do
      Mox.expect(Treasury.HttpMock, :get, fn request ->
        assert request == %{
                 headers: [
                   {"Authorization", "Bearer cL7FTRzqSfY8CpZXYJ53q2rpV4W5ybvddqObYiODJzc"}
                 ],
                 url: "https://treasury.app/api/v1/hiring/symbols/AAA"
               }

        fixture = "Ahhh"

        {:ok, %{body: fixture, status_code: 500}}
      end)

      assert Stocks.view_info("AAA") == {:error, "unexpected status code 500"}
    end

    test "A missing field is an error" do
      Mox.expect(Treasury.HttpMock, :get, fn request ->
        assert request == %{
                 headers: [
                   {"Authorization", "Bearer cL7FTRzqSfY8CpZXYJ53q2rpV4W5ybvddqObYiODJzc"}
                 ],
                 url: "https://treasury.app/api/v1/hiring/symbols/AAA"
               }

        fixture = "{\"name\":\"Apple Inc\",\"symbol\":\"AAPL\"}"

        {:ok, %{body: fixture, status_code: 200}}
      end)

      assert Stocks.view_info("AAA") ==
               {:error,
                %DataSchema.Errors{
                  errors: [price: "Field was required but value supplied is considered empty"]
                }}
    end
  end
end
