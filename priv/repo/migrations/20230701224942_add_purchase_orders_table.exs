defmodule Treasury.Repo.Migrations.AddPurchaseOrdersTable do
  use Ecto.Migration
  @table_comment "A table of orders to purchase stock at a given price"
  def change do
    create(table(:stocks, comment: "A table of stocks")) do
      add(:symbol, :text, null: false)
      timestamps()
    end

    create(table(:purchase_orders, comment: @table_comment)) do
      add(:stock_id, references(:stocks),
        null: false,
        comment: "The id of the stock we wish to purchase"
      )

      add(:amount, :decimal,
        null: false,
        comment: "The USD dollar amount of money the user wishes to spend on the stock"
      )

      timestamps()
    end
  end
end
