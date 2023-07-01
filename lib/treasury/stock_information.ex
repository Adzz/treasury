defmodule Treasury.StockInformation do
  @moduledoc """
  A struct to represent the response from a call to:

      "https://treasury.app/api/v1/hiring/symbols/"

  """
  require DataSchema
  alias Treasury.DataSchema.StringType
  alias Treasury.DataSchema.DecimalType

  @data_accessor DataSchema.MapAccessor
  DataSchema.data_schema(
    field: {:name, "name", StringType},
    field: {:price, "price", DecimalType},
    field: {:symbol, "symbol", StringType},
    field: {:expense_ratio_basis_points, "expense_ratio_basis_points", DecimalType},
    # This doesn't come in the response so we add it manually after casting for now.
    field: {:refreshed_on, "", &Treasury.StockInformation.utc_timestamp/1, optional?: true}
  )

  @doc """
  Casting function that will take an iso 8601 date time string and turn it into a DateTime.
  """
  def utc_timestamp(date_string) do
    {:ok, datetime, 0} = DateTime.from_iso8601(date_string)
    {:ok, Timex.format!(datetime, "{D} {Mfull} {YYYY} @ {h24}:{m}")}
  end
end
