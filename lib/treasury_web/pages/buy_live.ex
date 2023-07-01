defmodule TreasuryWeb.Pages.BuyLive do
  use TreasuryWeb, :live_view
  require Logger

  @impl true
  def render(assigns) do
    ~H"""
    <h1 class="text-xl font-semibold mb-4 text-white">Purchase Stocks</h1>
    <div>
      <p>Stock Symbol:</p>
      <p>Number of Shares:</p>
      <!-- calculate -->
      <TreasuryWeb.Components.StockInfo.stock_info_form symbols={@symbols} stock_form={@stock_form} />
    </div>
    <div>
      <.header class="mb-4">Latest Stock Info</.header>

      <%= if @stock_info do %>
        <TreasuryWeb.Components.StockInfo.info stock_info={@stock_info} show_purchase={false} />
      <% end %>
    </div>
    """
  end

  @impl true
  # We could have the optional stock symbol as a param and if it's there prefill the
  # form or data with prices... Probably want a refresh prices BTN or something too...
  def mount(params, _session, socket) do
    info = get_latest_stock_info(params)

    default_assigns = %{
      symbols: Treasury.Stocks.valid_stock_symbols(),
      stock_form: Phoenix.Component.to_form(%{"symbol" => "VTI"}, as: :stock_symbol),
      stock_info: info
    }

    {:ok, assign(socket, default_assigns)}
  end

  defp get_latest_stock_info(%{"stock" => symbol}) do
    case Treasury.Stocks.view_info(symbol) do
      {:ok, info} -> info
      {:error, _message} -> nil
    end
  end

  defp get_latest_stock_info(_), do: nil

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

        {:error, message} ->
          {:noreply, socket |> put_flash(:error, message)}
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
