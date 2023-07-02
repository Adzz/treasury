defmodule Treasury.Db.PurchaseOrder do
  use Ecto.Schema

  schema "purchase_orders" do
    belongs_to(:stock, Treasury.Db.Stock)
    field(:amount, :decimal)
    field(:share_price, :decimal)
    # This should probably be called number_of_stocks
    field(:number_of_shares, :decimal)
    field(:date_of_order, :utc_datetime)
    timestamps()
  end

  def create_changeset(attrs) do
    %__MODULE__{}
    |> Ecto.Changeset.cast(attrs, [
      :amount,
      :stock_id,
      :share_price,
      :number_of_shares,
      :date_of_order
    ])
    |> Ecto.Changeset.validate_required([
      :amount,
      :stock_id,
      :share_price,
      :number_of_shares,
      :date_of_order
    ])
  end
end
