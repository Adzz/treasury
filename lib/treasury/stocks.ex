defmodule Treasury.Stocks do
  @moduledoc """
  Functions that interact with stocks.
  """
  @root_url "https://treasury.app/api/v1/hiring/symbols/"
  @http Application.compile_env!(:treasury, :http_mod)

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
      now = Timex.format!(DateTime.utc_now(), "{D} {Mfull} {YYYY} @ {h24}:{m}")
      {:ok, %{info | refreshed_on: now}}
    else
      {:ok, %{status_code: code}} -> {:error, "unexpected status code #{code}"}
      {:error, message} -> {:error, message}
    end
  end

  @doc """
  Returns a list of valid stock symbols. In real life we could keep and maintain a proper
  dataset here, but for now this does.
  """
  def valid_stock_symbols() do
    ["VTI"]
  end

  @doc """
  Actions a purchase order to buy dollar_amount worth of stock in USD.
  """
  def purchase_stock(_stock_symbol, _dollar_amount) do
    {:error, "Not implemented"}
  end
end
