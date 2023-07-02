defmodule Treasury.DateTime do
  @behaviour Treasury.DateTimeBehaviour

  @impl true
  def utc_now() do
    DateTime.utc_now()
  end
end
