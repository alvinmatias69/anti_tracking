defmodule Storages.SiteParameter do
  use Ecto.Schema
  import Ecto.Changeset

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
end
