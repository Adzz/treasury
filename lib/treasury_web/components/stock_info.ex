defmodule TreasuryWeb.Components.StockInfo do
  use TreasuryWeb, :function_component

  attr(:stock_info, :map, required: true)
  attr(:show_purchase, :boolean, default: true)

  def info(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm flex flex-col outline rounded-lg p-6 outline-1">
      <h2 class="font-semibold mb-2"><%= @stock_info.symbol %></h2>
      <h3 class="font-semibold mb-2"><%= @stock_info.name %></h3>

      <table class="table-fixed mb-4">
        <thead class="">
          <tr>
            <th></th>
            <th></th>
          </tr>
        </thead>
        <tr>
          <td>Price</td>
          <td class="font-semibold text-emerald-400">£<%= @stock_info.price %></td>
        </tr>
        <tr>
          <td class="">Expense Ratio</td>
          <%= if @stock_info.expense_ratio_basis_points do %>
            <td class="font-semibold text-emerald-400">
              <%= @stock_info.expense_ratio_basis_points %> (basis points)
            </td>
          <% else %>
            <td class="font-semibold">
              -
            </td>
          <% end %>
        </tr>
      </table>
      <%= if @show_purchase do %>
        <div class="mb-4 text-pink-400 text-center">
          <.link
            navigate={~p"/buy?stock=#{@stock_info.symbol}"}
            class={[
              "underline outline-1 outline pt-2 pb-3 px-2 rounded-lg font-semibold",
              " hover:text-pink-400/90"
            ]}
          >
            <TreasuryWeb.CoreComponents.icon name="hero-arrow-top-right-on-square w-5" />
            Buy <%= @stock_info.symbol %> Stock
          </.link>
        </div>
      <% end %>
      <div class="flex flex-col mt-2">
        <sub class="self-start">(as of <%= @stock_info.refreshed_on %>)</sub>
      </div>
    </div>
    """
  end

  attr(:symbols, :list, required: true)
  # This should be the result of a Phoenix.Component.to_form, but I don't think that's a
  # type we can write here, so I am just using map.
  attr(:stock_form, :map, required: true)

  @doc """
  A form that lets us request up to date information for stocks.
  """
  def stock_info_form(assigns) do
    ~H"""
    <.form class="mb-6" for={@stock_form} phx-blur="select_stock" phx-submit="select_stock">
      <div class="flex flex-col items-center">
        <div class="flex flex-col">
          <.label class="self-start">Stock Symbol</.label>
          <input
            placeholder="type to filter..."
            name="stock_symbol"
            list="stock_symbols"
            value={@stock_form[:symbol].value}
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
    """
  end
end
