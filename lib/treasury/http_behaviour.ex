defmodule Treasury.HttpBehaviour do
  @typep url :: binary()
  @typep headers :: [{atom, binary}] | [{binary, binary}] | %{binary => binary}
  @typep options :: Keyword.t()
  @typep url_headers_options ::
           %{url: url}
           | %{url: url, options: options}
           | %{url: url, headers: headers}
           | %{url: url, headers: headers, options: options}
  @callback get(url_headers_options) :: {:ok, map()} | {:error, String.t() | map()}
end
