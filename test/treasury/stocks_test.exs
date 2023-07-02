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

  describe "purchase_stock/4" do
    test "Returns an error if the stock can't be found" do
      assert Stocks.purchase_stock("XXX", 400, 200, Decimal.new("2.50")) == {:error, :not_found}
    end

    test "Inserts a " do
      stock = %Treasury.Db.Stock{symbol: "YYY"} |> Repo.insert!()

      Mox.expect(Treasury.DateTimeMock, :utc_now, fn ->
        ~U[2023-07-02 03:34:22.755919Z]
      end)

      assert {:ok, %Treasury.Db.PurchaseOrder{} = created} =
               Stocks.purchase_stock(stock.symbol, 400, 200, Decimal.new("2.50"))

      db_order = Repo.get(Treasury.Db.PurchaseOrder, created.id)
      assert db_order.amount == Decimal.new("400")
      assert db_order.share_price == Decimal.new("2.50")
      assert db_order.number_of_shares == Decimal.new("200")
      assert db_order.date_of_order == ~U[2023-07-02 03:34:22Z]
    end
  end
end
