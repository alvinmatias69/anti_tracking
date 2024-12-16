defmodule Web.TrackerRouter do
  require Logger

  use Plug.Router

  plug(:match)

  import Plug.BasicAuth

  plug(:basic_auth,
    username: Application.compile_env(:web, :username),
    password: Application.compile_env(:web, :password)
  )

  plug(Plug.Parsers, parsers: [:json], json_decoder: Poison)

  plug(:dispatch)

  get "/:site_name" do
    payload =
      %{parameters: Storages.get(site_name)}
      |> Poison.encode!()

    conn
    |> send_json_response(200, payload)
  end

  post "/" do
    result =
      case parse_payload(conn.body_params) do
        {:ok, payload} -> Storages.insert(payload.site, payload.parameters)
        error -> error
      end

    case result do
      :ok ->
        conn
        |> send_resp(200, "ok")

      {:error, message} ->
        payload = Poison.encode!(%{error_message: message})

        conn
        |> send_json_response(400, payload)

      _ ->
        payload = Poison.encode!(%{error_message: "Server error, please try again"})

        conn
        |> send_json_response(500, payload)
    end
  end

  post "/unlink" do
    result =
      case parse_payload(conn.body_params) do
        {:ok, payload} -> Storages.unlink!(payload.site, payload.parameters)
        error -> error
      end

    case result do
      :ok ->
        conn
        |> send_resp(200, "ok")

      {:error, message} ->
        payload = Poison.encode!(%{error_message: message})

        conn
        |> send_json_response(400, payload)
    end
  end

  match _ do
    send_resp(conn, 404, "not found")
  end

  defp send_json_response(conn, status, payload) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, payload)
  end

  defp parse_payload(payload) do
    site_result =
      payload
      |> Map.get("site", "")
      |> validate_site()

    parameter_result =
      payload
      |> Map.get("parameters", [])
      |> validate_parameters()

    with {:ok, site} <- site_result,
         {:ok, parameters} <- parameter_result do
      {:ok, %{site: site, parameters: parameters}}
    end
  end

  defp validate_site(site) do
    case is_bitstring(site) do
      false -> {:error, "site value must be string"}
      true -> {:ok, site}
    end
  end

  defp validate_parameters(parameters) do
    case is_list(parameters) do
      false ->
        {:error, "parameters must be list of strings"}

      true ->
        parameters
        |> Enum.filter(fn item -> !is_bitstring(item) end)
        |> Enum.empty?()
        |> case do
          false -> {:error, "parameters must be list of strings"}
          true -> {:ok, parameters}
        end
    end
  end
end
