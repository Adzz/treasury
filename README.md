# Treasury

## First Time Setup

Start docker for mac, then start the DB

```sh
make db_hidden
```

Create and seed the DB

```sh
mix ecto.setup
```

Now start:

```sh
iex -S mix phx.server
```

You can see the app on `http://localhost:4000`
