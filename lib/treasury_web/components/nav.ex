defmodule TreasuryWeb.Components.Nav do
  use TreasuryWeb, :function_component

  def nav(assigns) do
    ~H"""
    <nav class={[
      "border-b-2 py-4 w-full bg-slate-900"
    ]}>
      <ul
        id="expanded_nav_menu"
        class={[
          "ml-4 ",
          "flex flex-row space-x-4",
          "w-screen items-center bg-slate-900 "
        ]}
      >
        <.nav_item to={~p"/stocks"} label="Stock Info">
          <:icon><.icon name="hero-information-circle" /></:icon>
        </.nav_item>
        <.nav_item to={~p"/buy"} label="Buy Stock">
          <:icon><.icon name="hero-currency-dollar" /></:icon>
        </.nav_item>
        <.nav_item to={~p"/portfolio"} label="Portfolio">
          <:icon><.icon name="hero-currency-dollar" /></:icon>
        </.nav_item>
      </ul>
    </nav>
    """
  end

  slot(:icon, required: true)
  attr(:label, :string, required: true)
  attr(:to, :any, required: true)

  def nav_item(assigns) do
    ~H"""
    <li class="hover:text-slate-500/70">
      <.link navigate={@to} class="w-full inline-block">
        <span><%= render_slot(@icon) %></span> <%= @label %>
      </.link>
    </li>
    """
  end
end
