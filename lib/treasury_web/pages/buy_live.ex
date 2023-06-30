defmodule TreasuryWeb.Pages.BuyLive do
  use TreasuryWeb, :live_view
  require Logger

  @impl true
  def render(assigns) do
    ~H"""
    <h1 class="text-xl font-semibold mb-4">Purchase Stocks</h1>
    <div></div>
    """
  end

  @impl true
  # We could have the optional stock symbol as a param and if it's there prefill the
  # form or data with prices... Probably want a refresh prices BTN or something too...
  def mount(_params, _session, socket) do
    default_assigns = %{}
    {:ok, assign(socket, default_assigns)}
  end

  @impl true
  def handle_event(event, params, socket) do
    Logger.error("unrecognised event: #{event} with params: #{inspect(params)}")

    {:noreply, socket}
  end
end
