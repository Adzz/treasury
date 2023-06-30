defmodule TreasuryWeb.Components.StockInfo do
  use TreasuryWeb, :function_component

  attr(:stock_info, :map, required: true)
  attr(:show_purchase, :boolean, default: true)

  def info(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm flex flex-col">
      <h2 class="font-semibold mb-2 text-center"><%= @stock_info["symbol"] %></h2>
      <h3 class="font-semibold mb-2"><%= @stock_info["name"] %></h3>

      <table class="table-fixed">
        <thead class="">
          <tr>
            <th></th>
            <th></th>
          </tr>
        </thead>
        <tr>
          <td>Price</td>
          <td class="font-semibold">£<%= @stock_info["price"] %></td>
        </tr>
        <tr>
          <td class="">Expense Ratio</td>
          <td class="font-semibold">
            <%= @stock_info["expense_ratio_basis_points"] %> (basis points)
          </td>
        </tr>
      </table>
      <%= if @show_purchase do %>
        <div class="mt-2">
          <TreasuryWeb.CoreComponents.icon name="hero-arrow-top-right-on-square w-5" />
          <.link navigate={~p"/buy?stock=#{@stock_info["symbol"]}"} class="underline font-semibold">
            Buy <%= @stock_info["symbol"] %> Stocks
          </.link>
        </div>
      <% end %>
    </div>
    """
  end
end
