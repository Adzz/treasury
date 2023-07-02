defmodule TreasuryWeb.Pages.PortfolioLive do
  use TreasuryWeb, :live_view
  require Logger
  alias Treasury.Stocks

  @impl true
  def render(assigns) do
    ~H"""
    <h1 class="text-xl font-semibold mb-4">Portfolio</h1>
    <div class="">
      <table class="mx-auto mb-4">
        <thead class="">
          <tr>
            <th class="pr-4">Stock Symbol</th>
            <th class="pr-4">Total Investment</th>
            <th class="">No. of Stocks</th>
          </tr>
        </thead>
        <tbody>
          <%= for purchase_order <- @purchase_orders do %>
            <tr>
              <td class="font-semibold text-amber-500">
                <p class="mr-2"><%= purchase_order.symbol %></p>
              </td>
              <td class="font-semibold text-emerald-400">
                <p class="">$<%= Decimal.round(purchase_order.amount, 2) %></p>
              </td>
              <td class="font-semibold text-pink-400">
                <p class=""><%= Decimal.round(purchase_order.stock, 2) %></p>
              </td>
            </tr>
          <% end %>
        </tbody>
      </table>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    default_assigns = %{
      purchase_orders: Stocks.purchase_orders()
    }

    {:ok, assign(socket, default_assigns)}
  end

  @impl true
  def handle_event(event, params, socket) do
    Logger.error("unrecognised event: #{event} with params: #{inspect(params)}")

    {:noreply, socket}
  end
end
