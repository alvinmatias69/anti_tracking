defmodule Storages do
  require Ecto.Query

  def insert(site_name, parameter_names, {:update_cache, true}) do
    insert(site_name, parameter_names)
    |> Storages.Cache.add(site_name, parameter_names)
  end

  def insert(site_name \\ "generic", parameter_names \\ []) do
    site =
      %{name: Storages.Util.normalize_url(site_name)}
      |> insert_or_get(%Storages.Site{}, Storages.Site)

    parameters =
      parameter_names
      |> Stream.map(fn name ->
        parameter =
          %{name: name}
          |> insert_or_get(%Storages.Parameter{}, Storages.Parameter)
          # TODO: Improve this so the get only use a single query
          |> Storages.Repo.preload([:sites])

        {:ok, result} =
          parameter
          |> Ecto.Changeset.change()
          |> Ecto.Changeset.put_assoc(:sites, [site | parameter.sites])
          |> Storages.Repo.update()

        result.name
      end)
      |> Enum.to_list()

    {site.name, parameters}
  end

  def get(site_name, {:with_cache, true}) do
    # TODO: improve this to avoid calling normalize_url multiple times
    case Storages.Cache.lookup(Storages.Util.normalize_url(site_name)) do
      [] ->
        parameters = get(site_name)
        Storages.Cache.add({site_name, parameters})
        parameters

      result ->
        result
    end
  end

  def get(site_name) do
    site =
      Ecto.Query.from(s in Storages.Site,
        where: s.name == ^Storages.Util.normalize_url(site_name),
        join: p in assoc(s, :parameters),
        preload: [parameters: p]
      )
      |> Storages.Repo.all()

    case site do
      [site] ->
        site.parameters |> Enum.map(fn parameter -> parameter.name end)

      _ ->
        []
    end
  end

  defp insert_or_get(payload, entity, module) do
    entity
    |> module.changeset(payload)
    |> Storages.Repo.insert()
    |> handle_insert(module)
  end

  defp handle_insert({:ok, result}, _), do: result

  defp handle_insert({:error, changeset}, queryable) do
    true = Enum.any?(changeset.errors, &violate_unique_constraint?/1)
    %{name: name} = changeset.changes
    Storages.Repo.get_by(queryable, name: name)
  end

  defp violate_unique_constraint?({_, {_, [constraint: :unique, constraint_name: _]}}), do: true
  defp violate_unique_constraint?(_), do: false
end
