defmodule Storages.SiteParameter do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  @primary_key false

  schema "site_parameters" do
    field(:site_id, :integer)
    field(:parameter_id, :integer)
  end

  def changeset(site_parameter, params \\ %{}) do
    site_parameter
    |> cast(params, [:site_id, :parameter_id])
    |> validate_required([:site_id, :parameter_id])
    |> unique_constraint(:site_parameters_unique_constraint,
      name: :site_parameters_composite_index
    )
  end

  def insert_ignore(payload) do
    %Storages.SiteParameter{}
    |> changeset(payload)
    |> Storages.Repo.insert()
    |> case do
      {:ok, _} ->
        :ok

      {:error, changeset} ->
        {:nochange, changeset.errors}
    end
  end

  def delete(nil, []), do: {0, nil}

  def delete(site_id, parameter_ids) do
    Storages.SiteParameter
    |> build_site_condition(site_id)
    |> build_param_condition(parameter_ids)
    |> Storages.Repo.delete_all()
  end

  defp build_site_condition(entity, nil), do: entity
  defp build_site_condition(entity, site_id), do: entity |> where([sp], sp.site_id == ^site_id)

  defp build_param_condition(entity, []), do: entity

  defp build_param_condition(entity, parameter_ids),
    do: entity |> where([sp], sp.parameter_id in ^parameter_ids)
end
