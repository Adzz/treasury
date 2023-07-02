defmodule Treasury.DateTimeBehaviour do
  @callback utc_now() :: DateTime.t()
end
