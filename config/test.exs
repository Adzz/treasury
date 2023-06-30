import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config(:treasury, Treasury.Repo,
  username: "treasury_user",
  password: "treasury_123",
  hostname: "localhost",
  database: "treasury_test",
  pool: Ecto.Adapters.SQL.Sandbox,
  show_sensitive_data_on_connection_error: true,
  stacktrace: true,
  port: 54321,
  pool_size: 10
)

config(:treasury, http_mod: Treasury.HttpMock)

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :treasury, TreasuryWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "0NBxc9JlUusVr+yKPmOaZLAmmNqnDKqZlrRknSnKq68xpBQoZLfaKnNfloGQcWGW",
  server: false

# In test we don't send emails.
config :treasury, Treasury.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
