defmodule Bot.MessageHandler do
  @spec handle(String.t()) :: nil | :ok
  def handle(message) do
    message
    |> Bot.Util.normalize()
    |> String.split()
    |> Enum.map(&Bot.Util.parse_url/1)
    |> Enum.reduce([], fn item, acc ->
      case item do
        {:ok, %URI{query: nil}} -> acc
        {:ok, uri} -> [uri | acc]
        _ -> acc
      end
    end)
    |> Enum.map(&cleanup_uri/1)
    |> Enum.reduce([], fn item, acc ->
      case item do
        {:ok, uri} ->
          [uri | acc]

        _ ->
          acc
      end
    end)
    |> send()
  end

  defp cleanup_uri(uri) do
    %URI{host: host, query: query} = uri
    query = URI.decode_query(query)

    cleaned_query =
      Storages.get(host, {:with_cache, true})
      |> Enum.reduce(query, fn item, acc ->
        Map.delete(acc, item)
      end)

    cond do
      Map.equal?(query, cleaned_query) ->
        {:noop, uri}

      %{} == cleaned_query ->
        {:ok, %{uri | query: nil}}

      true ->
        {:ok, %{uri | query: URI.encode_query(cleaned_query)}}
    end
  end

  defp send([]), do: nil

  defp send(uris) do
    uris
    |> Enum.reduce("Here's your cleaned up urls:", fn item, acc ->
      acc <> "\n - " <> URI.to_string(item)
    end)
    |> Bot.cast_message()
  end
end
