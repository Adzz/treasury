defmodule Treasury.Stocks do
  @moduledoc """
  Functions that interact with stocks.
  """
  @root_url "https://treasury.app/api/v1/hiring/symbols/"

  @doc """
  Queries an API for information on a stock symbol.
  """
  def view_info(symbol) do
    # obviously IRL we would do something better here:
    headers = [{"Authorization", "Bearer cL7FTRzqSfY8CpZXYJ53q2rpV4W5ybvddqObYiODJzc"}]

    with {:ok, %{body: body, status_code: 200}} <-
           Treasury.Http.get(%{url: @root_url <> symbol, headers: headers}) do
      Jason.decode(body)
    else
      {:ok, %{status_code: code}} -> {:error, "unexpected status code #{code}"}
      {:error, message} -> {:error, message}
    end
  end
end
