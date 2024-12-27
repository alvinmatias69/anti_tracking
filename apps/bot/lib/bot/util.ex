defmodule Bot.Util do
  @doc ~S"""
  Normalize message, strip its sender

  ## Examples

    iex> Bot.Util.normalize("1ce360e7-03a3-4a1a-8ca4-859bec4317ea: hello")
    "hello"

    iex> Bot.Util.normalize("1ce360e7-03a3-4a1a-8ca4-859bec4317ea: hello: again")
    "hello: again"
  """
  @spec normalize(String.t()) :: String.t()
  def normalize(message) do
    Regex.replace(~r/[a-zA-Z0-9\-]*: /, message, "", global: false)
  end

  @spec parse_url(String.t()) :: tuple()
  def parse_url(string) do
    case URI.parse(string) do
      %URI{scheme: nil} -> {:error, nil}
      %URI{host: nil} -> {:error, nil}
      uri -> {:ok, uri}
    end
  end
end
