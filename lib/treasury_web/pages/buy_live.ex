defmodule TreasuryWeb.Pages.BuyLive do
  use TreasuryWeb, :live_view
  require Logger

  @impl true
  def render(assigns) do
    ~H"""
    <h1 class="text-xl font-semibold mb-4 text-white">Purchase Stocks</h1>
    <div>
      <%= if @stock_info do %>
        <.header>
          Latest Stock Info
          <:subtitle>(As of <%= @info_date %>)</:subtitle>
        </.header>
      <% else %>
        <.header>
          Latest Stock Info
        </.header>
      <% end %>

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
    {info, date_requested} = get_latest_stock_info(params)

    default_assigns = %{
      stock_form: Phoenix.Component.to_form(%{}, as: :stock_symbol),
      stock_info: info,
      info_date: date_requested
    }

    {:ok, assign(socket, default_assigns)}
  end

  defp get_latest_stock_info(%{"stock" => symbol}) do
    case Treasury.Stocks.view_info(symbol) do
      {:ok, info} ->
        {info, Timex.format!(DateTime.utc_now(), "{D} {Mfull} {YYYY} @ {h24}:{m}")}

      {:error, _message} ->
        {nil, nil}
    end
  end

  defp get_latest_stock_info(_), do: {nil, nil}

  @impl true
  def handle_event(event, params, socket) do
    Logger.error("unrecognised event: #{event} with params: #{inspect(params)}")

    {:noreply, socket}
  end
end
