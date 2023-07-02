defmodule Treasury.Repo.Migrations.AddFieldsToPurchaseOrder do
  use Ecto.Migration

  def change do
    alter(table(:purchase_orders)) do
      add(:share_price, :decimal,
        null: false,
        comment: "the USD price of the stock at the time of the purchase order"
      )

      add(:date_of_order, :utc_datetime,
        null: false,
        comment: "The date the order was placed, may be different from inserted at"
      )

      add(:number_of_shares, :decimal,
        null: false,
        comment:
          "The number of shares given the price at the time of the order and the amount spent."
      )
    end

    create(unique_index(:stocks, :symbol))
  end
end
