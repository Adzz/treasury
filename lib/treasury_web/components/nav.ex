defmodule TreasuryWeb.Components.Nav do
  use TreasuryWeb, :function_component

  def nav(assigns) do
    ~H"""
    <nav class={[
      "flex relative z-20",
      "xl:flex-row xl:space-x-4",
      "items-center border-b-2 py-4 w-full bg-slate-900"
    ]}>
      <ul
        id="expanded_nav_menu"
        class={[
          "ml-4",
          "flex flex-row space-x-4 space-y-0 relative top-0 border-b-0",
          "w-screen space-y-2 bg-slate-900 border-b-2"
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
    <li class="hover:md:bg-slate-900 hover:bg-slate-500/50">
      <.link navigate={@to} class="w-full inline-block">
        <span><%= render_slot(@icon) %></span> <%= @label %>
      </.link>
    </li>
    """
  end
end
