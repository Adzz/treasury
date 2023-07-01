defmodule TreasuryWeb.Pages.BuyLive do
  use TreasuryWeb, :live_view
  require Logger

  @impl true
  def render(assigns) do
    ~H"""
    <h1 class="text-xl font-semibold mb-2 text-white">Purchase Stocks</h1>
    <p class="">Enter stock symbol for the stock you wish to purchase below,</p>
    <p class="">then enter the dollar amount you wish to spend on the stock.</p>
    <p class="mb-4">Press purchase to action the purchase.</p>
    <div class="mb-4">
      <.header class="mb-4">Latest Stock Info</.header>
      <TreasuryWeb.Components.StockInfo.stock_info_form symbols={@symbols} stock_form={@stock_form} />
      <%= if @stock_info do %>
        <TreasuryWeb.Components.StockInfo.info stock_info={@stock_info} show_purchase={false} />
      <% end %>
    </div>
    <div class="flex flex-col items-center text-white">
      <.form
        class="mb-6"
        for={@buy_stock_form}
        phx-change="update_amount"
        phx-blur="buy_stock"
        phx-submit="buy_stock"
      >
        <div class="flex flex-col">
          <.input
            class={
            "text-slate-50 mt-1 block py-2 px-3 border focus:border-gray-300 " <>
            "bg-slate-900 rounded-md shadow-sm focus:outline-none " <>
            "focus:ring-zinc-500 focus:border-zinc-500 sm:text-sm" <>
            " max-w-xs disabled:cursor-not-allowed"
          }
            disabled={!@stock_info}
            type="number"
            step="0.05"
            label="Amount (USD)"
            field={@buy_stock_form[:amount]}
          />
          <.button class="mt-4 self-end">Purchase</.button>
        </div>
      </.form>
      <%= if @number_of_stocks > 0 do %>
        <p class="">
          Buys <%= @number_of_stocks %> of <%= @stock_info.symbol %> stock.
        </p>
      <% end %>
    </div>
    """
  end

  @impl true
  # We could have the optional stock symbol as a param and if it's there prefill the
  # form or data with prices... Probably want a refresh prices BTN or something too...
  def mount(params, _session, socket) do
    info = get_latest_stock_info(params)
    default_form_params = if info, do: %{"symbol" => info.symbol}, else: %{}

    default_assigns = %{
      symbols: Treasury.Stocks.valid_stock_symbols(),
      stock_form: Phoenix.Component.to_form(default_form_params, as: :stock_symbol),
      stock_info: info,
      buy_stock_form: Phoenix.Component.to_form(%{}, as: :buy_stock),
      number_of_stocks: 0
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
  def handle_event("update_amount", %{"buy_stock" => %{"amount" => ""}}, socket) do
    new_assigns = %{
      number_of_stocks: 0
    }

    {:noreply, assign(socket, new_assigns)}
  end

  @impl true
  def handle_event("update_amount", %{"buy_stock" => %{"amount" => amount}}, socket) do
    number_of_stocks =
      amount
      |> Decimal.new()
      |> Decimal.div(socket.assigns.stock_info.price)
      |> Decimal.round(4)

    new_assigns = %{
      number_of_stocks: number_of_stocks
    }

    {:noreply, assign(socket, new_assigns)}
  end

  @impl true
  def handle_event("buy_stock", %{"buy_stock" => %{"amount" => amount}}, socket) do
    case Treasury.Stocks.purchase_stock(socket.assigns.stock_info.symbol, amount) do
      {:ok, purchase_order} ->
        new_assigns = %{
          number_of_stocks: 0
        }

        {:noreply, assign(socket, new_assigns) |> put_flash(:info, "Successfully placed order")}

      {:error, message} ->
        {:noreply, socket |> put_flash(:error, message)}
    end
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
