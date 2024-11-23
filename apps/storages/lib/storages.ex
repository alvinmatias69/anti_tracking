defmodule Storages do
  require Logger

  @spec insert(String.t(), [String.t()], {:update_cache, true}) :: {:error, String.t()} | :ok
  def insert(site_name, parameter_names, {:update_cache, true}) do
    case insert(site_name, parameter_names) do
      :ok ->
        Storages.Cache.update(site_name, parameter_names)
        :ok

      err ->
        err
    end
  end

  @spec insert(<<>>, [String.t()]) :: {:error, String.t()}
  def insert("", _parameter_names) do
    {:error, "site name is mandatory"}
  end

  @spec insert(String.t(), []) :: {:error, String.t()}
  def insert(_site_name, []) do
    {:error, "required at least one parameter name"}
  end

  @spec insert(String.t(), [String.t()]) :: {:error, String.t()} | :ok
  def insert(site_name, parameter_names) do
    site_name
    |> Storages.Util.normalize_url()
    |> Storages.Site.get_or_insert()
    |> case do
      {:error, changeset} ->
        Logger.error("changeset error: #{changeset.errors}")
        {:error, "error while fetching / inserting data to db"}

      {:ok, site_id} ->
        Logger.info("success fetch / insert with id: #{site_id}")

        parameters =
          parameter_names
          |> Storages.Parameter.get_id_name_by_names()

        parameter_names
        |> Stream.filter(&(!Map.has_key?(parameters, &1)))
        |> Stream.map(&%{name: &1})
        |> Enum.to_list()
        |> Storages.Parameter.insert_all!()
        |> Enum.concat(Map.values(parameters))
        |> Enum.map(&%{site_id: site_id, parameter_id: &1})
        |> Storages.SiteParameter.insert_all()

        :ok
    end
  end

  @spec get(String.t(), {:with_cache, true}) :: [String.t()]
  def get(site_name, {:with_cache, true}) do
    site_name
    |> Storages.Util.normalize_url()
    |> Storages.Cache.lookup()
    |> case do
      [] ->
        Logger.info("cache miss, trying to fetch from db")
        parameters = get(site_name)
        Storages.Cache.add(site_name, parameters)
        parameters

      result ->
        Logger.info("cache hit")
        result
    end
  end

  @spec get(String.t()) :: [String.t()]
  def get(site_name) do
    site_name
    |> Storages.Util.normalize_url()
    |> Storages.Site.get_with_parameters()
    |> case do
      nil ->
        []

      site ->
        site.parameters |> Enum.map(fn parameter -> parameter.name end)
    end
  end

  @spec unlink!(String.t(), [String.t()]) :: :ok
  def unlink!(site_name \\ "", parameter_names \\ []) do
    site_id =
      site_name
      |> Storages.Util.normalize_url()
      |> Storages.Site.get_id_by_name()

    parameter_ids = Storages.Parameter.get_ids_by_names(parameter_names)
    {_, nil} = Storages.SiteParameter.delete(site_id, parameter_ids)
    Storages.Cache.reset()
    :ok
  end
end
