defmodule Storages.Site do
  use Ecto.Schema
  require Ecto.Query
  import Ecto.Changeset
  import Ecto.Query

  schema "sites" do
    field(:name, :string)
    many_to_many(:parameters, Storages.Parameter, join_through: "site_parameters")
  end

  def changeset(site, params \\ %{}) do
    site
    |> cast(params, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end

  def get_with_parameters(name) do
    from(s in Storages.Site,
      where: s.name == ^name,
      join: p in assoc(s, :parameters),
      preload: [parameters: p]
    )
    |> Storages.Repo.all()
  end

  def get_id_by_name(""), do: nil

  def get_id_by_name(name) do
    Storages.Repo.get_by(Storages.Site, name: name)
    |> case do
      nil ->
        nil

      result ->
        result.id
    end
  end
end
