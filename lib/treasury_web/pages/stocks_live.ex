defmodule TreasuryWeb.Pages.StocksLive do
  use TreasuryWeb, :live_view
  require Logger

  @impl true
  def render(assigns) do
    ~H"""
    <div class="ml-4">
      <h1 class="text-xl font-semibold mb-4">View Stocks</h1>
      <TreasuryWeb.Components.StockInfo.stock_info_form symbols={@symbols} stock_form={@stock_form} />
      <%= if @stock_info do %>
        <TreasuryWeb.Components.StockInfo.info stock_info={@stock_info} />
      <% end %>
    </div>
    """
  end

  @impl true
  @doc """
  Here is an example response you can hardcode to develop against:
  stock_info:  %Treasury.StockInformation{
     name: "Vanguard Group, Inc. - Vanguard Total Stock Market ETF",
     price: Decimal.new("220.28"),
     symbol: "VTI",
     expense_ratio_basis_points: Decimal.new("3"),
     refreshed_on: "1 July 2023 @ 21:35"
   }
  """
  def mount(_params, _session, socket) do
    default_assigns = %{
      symbols: Treasury.Stocks.valid_stock_symbols(),
      stock_form: Phoenix.Component.to_form(%{}, as: :select_stock),
      stock_info: nil
    }

    {:ok, assign(socket, default_assigns)}
  end

  @impl true
  def handle_event("select_stock", %{"stock_symbol" => symbol}, socket) do
    exists? = Enum.find(socket.assigns.symbols, &(&1 == symbol))

    if exists? do
      case Treasury.Stocks.view_info(symbol) do
        {:ok, info} ->
          new_assigns = %{
            stock_info: info
          }

          {:noreply, assign(socket, new_assigns)}

        {:error, message} when is_binary(message) ->
          {:noreply, socket |> put_flash(:error, message)}

        {:error, message} ->
          {:noreply, socket |> put_flash(:error, inspect(message))}
      end
    else
      {:noreply, socket |> put_flash(:error, "#{symbol} is not a known stock symbol")}
    end
  end

  @impl true
  def handle_event(event, params, socket) do
    Logger.error("unrecognised event: #{event} with params: #{inspect(params)}")

    {:noreply, socket}
  end
end
