defmodule TreasuryWeb.Pages.StocksLive do
  use TreasuryWeb, :live_view
  require Logger

  @impl true
  def render(assigns) do
    ~H"""
    <div class="ml-4">
      <h1 class="text-xl font-semibold mb-4">View Stocks</h1>
      <.form class="mb-6" for={@stock_form} phx-blur="select_stock" phx-submit="select_stock">
        <div class="flex flex-col items-center">
          <div class="flex flex-col">
            <.label class="self-start">Stock Symbol</.label>
            <input
              placeholder="type to filter..."
              name="stock_symbol"
              list="stock_symbols"
              required={true}
              class={[
                "text-slate-50 mt-1 block py-2 px-3 border focus:border-gray-300 ",
                "bg-slate-900 rounded-md shadow-sm focus:outline-none ",
                "focus:ring-zinc-500 focus:border-zinc-500 sm:text-sm"
              ]}
            />
            <datalist id="stock_symbols">
              <%= for symbol <- @symbols do %>
                <option value={symbol} />
              <% end %>
            </datalist>
            <.button class="mt-4 self-end">Submit</.button>
          </div>
        </div>
      </.form>

      <%= if @stock_info do %>
        <TreasuryWeb.Components.StockInfo.info stock_info={@stock_info} />
      <% end %>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    default_assigns = %{
      symbols: ["VTI"],
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
