# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Treasury.Repo.insert!(%Treasury.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

# We upsert to make seeding idempotent.
Treasury.Repo.insert!(%Treasury.Db.Stock{symbol: "VTI"},
  on_conflict: :nothing,
  conflict_target: [:symbol]
)

Treasury.Repo.insert!(%Treasury.Db.Stock{symbol: "META"},
  on_conflict: :nothing,
  conflict_target: [:symbol]
)

Treasury.Repo.insert!(%Treasury.Db.Stock{symbol: "GOOG"},
  on_conflict: :nothing,
  conflict_target: [:symbol]
)

Treasury.Repo.insert!(%Treasury.Db.Stock{symbol: "AMZN"},
  on_conflict: :nothing,
  conflict_target: [:symbol]
)

Treasury.Repo.insert!(%Treasury.Db.Stock{symbol: "AAPL"},
  on_conflict: :nothing,
  conflict_target: [:symbol]
)

Treasury.Repo.insert!(%Treasury.Db.Stock{symbol: "NVDA"},
  on_conflict: :nothing,
  conflict_target: [:symbol]
)
