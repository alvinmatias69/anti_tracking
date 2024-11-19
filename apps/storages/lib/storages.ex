defmodule Storages do
  require Logger

  def insert(site_name, parameter_names, {:update_cache, true}) do
    case insert(site_name, parameter_names) do
      :ok ->
        Storages.Cache.update(site_name, parameter_names)
    end
  end

  def insert(site_name \\ "generic", parameter_names \\ []) do
    site =
      %{name: Storages.Util.normalize_url(site_name)}
      |> Storages.Util.get_or_insert(%Storages.Site{}, Storages.Site)

    parameter_names
    |> Stream.map(&%{name: &1})
    |> Stream.map(&Storages.Util.get_or_insert(&1, %Storages.Parameter{}, Storages.Parameter))
    |> Stream.map(&%{site_id: site.id, parameter_id: &1.id})
    |> Stream.map(&Storages.SiteParameter.insert_ignore/1)
    |> Enum.each(fn result ->
      case result do
        :ok -> Logger.info("Succes link site with parameter")
        {:nochange, _} -> Logger.info("no change added")
      end
    end)

    :ok
  end

  def get(site_name, {:with_cache, true}) do
    # TODO: improve this to avoid calling normalize_url multiple times
    site_name
    |> Storages.Util.normalize_url()
    |> Storages.Cache.lookup()
    |> case do
      [] ->
        parameters = get(site_name)
        Storages.Cache.add(site_name, parameters)
        parameters

      result ->
        result
    end
  end

  def get(site_name) do
    site_name
    |> Storages.Util.normalize_url()
    |> Storages.Site.get_with_parameters()
    |> case do
      [site] ->
        site.parameters |> Enum.map(fn parameter -> parameter.name end)

      _ ->
        []
    end
  end

  def unlink(site_name \\ "", parameter_names \\ []) do
    site_id =
      site_name
      |> Storages.Util.normalize_url()
      |> Storages.Site.get_id_by_name()

    parameter_ids = Storages.Parameter.get_ids_by_names(parameter_names)
    Storages.SiteParameter.delete(site_id, parameter_ids)
  end
end
