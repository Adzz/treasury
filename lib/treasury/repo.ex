defmodule Treasury.Repo do
  use Ecto.Repo,
    otp_app: :treasury,
    adapter: Ecto.Adapters.Postgres
end
