defmodule TreasuryWeb.Pages.HomeLive do
  use TreasuryWeb, :live_view
  require Logger

  @impl true
  def render(assigns) do
    ~H"""
    <h1 class="text-xl font-semibold mb-4">Welcome To Treasury</h1>
    <div class="flex items-center justify-center">
      <ul class="text-lg">
        <li>
          <.icon name="hero-arrow-top-right-on-square" />
          <.link navigate={~p"/portfolio"} class="underline">View Portfolio</.link>
        </li>
        <li>
          <.icon name="hero-arrow-top-right-on-square" />
          <.link navigate={~p"/stocks"} class="underline"> View Stock</.link>
        </li>
        <li>
          <.icon name="hero-arrow-top-right-on-square" />
          <.link navigate={~p"/buy"} class="underline"> Buy Stocks</.link>
        </li>
      </ul>
    </div>
    """
  end

  @impl true
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
