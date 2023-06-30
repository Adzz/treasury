defmodule Treasury.Http do
  @moduledoc """
  A wrapper around the given HTTP library we are currently using.
  """
  @behaviour Treasury.HttpBehaviour

  @impl true
  def get(args = %{url: url}) do
    options = Map.get(args, :options, [])
    headers = Map.get(args, :headers, [])

    HTTPoison.get(url, headers, options)
    |> process_response()
  end

  defp process_response(
         {:ok,
          %HTTPoison.Response{
            status_code: status_code,
            body: body,
            headers: headers,
            request_url: request_url
          }}
       ) do
    {:ok,
     %{
       status_code: status_code,
       body: body,
       headers: headers,
       request_url: request_url
     }}
  end

  defp process_response({:error, %HTTPoison.Error{reason: reason}}) do
    {:error, reason}
  end
end
