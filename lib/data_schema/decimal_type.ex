defmodule Treasury.DataSchema.DecimalType do
  @behaviour DataSchema.CastBehaviour

  @impl true
  def cast(string) when is_binary(string) do
    {:ok, Decimal.new(string)}
  end

  @impl true
  def cast(float) when is_float(float) do
    {:ok, Decimal.from_float(float)}
  end

  @impl true
  def cast(int) when is_integer(int) do
    {:ok, Decimal.new(int)}
  end

  @impl true
  def cast(value) do
    {:error, "Could not cast to decimal #{inspect(value)}"}
  end
end
