defmodule Treasury.Stocks do
  @moduledoc """
  Functions that interact with stocks.
  """
  @root_url "https://treasury.app/api/v1/hiring/symbols/"
  @http Application.compile_env!(:treasury, :http_mod)
  @datetime Application.compile_env!(:treasury, :datetime_mod)

  alias Treasury.Repo
  alias Treasury.Db.Stock
  alias Treasury.Db.PurchaseOrder
  import Ecto.Query

  @doc """
  Queries an API for information on a stock symbol.
  """
  def view_info(symbol) do
    # obviously IRL we would do something better here:
    headers = [{"Authorization", "Bearer cL7FTRzqSfY8CpZXYJ53q2rpV4W5ybvddqObYiODJzc"}]

    with {:ok, %{body: body, status_code: 200}} <-
           @http.get(%{url: @root_url <> symbol, headers: headers}),
         {:ok, json} <- Jason.decode(body),
         {:ok, info} <- DataSchema.to_struct(json, Treasury.StockInformation) do
      now = Timex.format!(@datetime.utc_now(), "{D} {Mfull} {YYYY} @ {h24}:{m}")
      {:ok, %{info | refreshed_on: now}}
    else
      {:ok, %{status_code: code}} -> {:error, "unexpected status code #{code}"}
      {:error, message} -> {:error, message}
    end
  end

  @doc """
  Returns a list of valid stock symbols. In real life we could keep and maintain a proper
  dataset here, but for now this does. You can seed it with `mix ecto.setup`
  """
  def valid_stock_symbols() do
    Repo.all(from(s in Stock, select: s.symbol))
  end

  @doc """
  Aggregates information for all of the purchase orders we have made on different stocks.
  """
  def purchase_orders() do
    from(
      po in PurchaseOrder,
      join: s in assoc(po, :stock),
      group_by: po.stock_id,
      select: %{
        amount: sum(po.amount),
        stock_id: po.stock_id,
        symbol: min(s.symbol),
        stock: sum(po.number_of_shares)
      }
    )
    |> Repo.all()
  end

  @doc """
  Actions a purchase order to buy dollar_amount worth of stock in USD.
  """
  def purchase_stock(stock_symbol, dollar_amount, number_of_stocks, price) do
    with %{} = stock <- Repo.get_by(Stock, symbol: stock_symbol) do
      %{
        stock_id: stock.id,
        amount: dollar_amount,
        number_of_shares: number_of_stocks,
        share_price: price,
        date_of_order: @datetime.utc_now() |> DateTime.truncate(:millisecond)
      }
      |> PurchaseOrder.create_changeset()
      |> Repo.insert()
    else
      nil -> {:error, :not_found}
    end
  end
end
