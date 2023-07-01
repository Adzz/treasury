defmodule Treasury.Db.PurchaseOrder do
  use Ecto.Schema

  schema "purchase_orders" do
    belongs_to(:stock, Treasury.Db.Stock)
    field(:amount, :decimal)
    timestamps()
  end

  def create_changeset(attrs) do
    %__MODULE__{}
    |> Ecto.Changeset.cast(attrs, [:amount, :stock_id])
    |> Ecto.Changeset.validate_required([:amount, :stock_id])
  end
end
