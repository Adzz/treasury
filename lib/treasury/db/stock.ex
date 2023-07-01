defmodule Treasury.Db.Stock do
  use Ecto.Schema

  schema "stocks" do
    field(:symbol, :string)
    has_many(:purchase_orders, Treasury.Db.PurchaseOrder)
    timestamps()
  end
end
