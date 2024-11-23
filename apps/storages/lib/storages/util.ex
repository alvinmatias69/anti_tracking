defmodule Storages.Util do
  @doc ~S"""
  Normalize url, strip its scheme and www subdomain

  ## Examples

    iex> Storages.Util.normalize_url("https://www.example.com")
    "example.com"
  """
  @spec normalize_url(String.t()) :: String.t()
  def normalize_url(url) do
    url
    |> String.replace_prefix("http://", "")
    |> String.replace_prefix("https://", "")
    |> String.replace_prefix("www.", "")
  end
end
