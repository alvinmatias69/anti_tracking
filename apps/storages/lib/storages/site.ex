defmodule Storages.Site do
  use Ecto.Schema
  require Ecto.Query
  import Ecto.Changeset

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
    Ecto.Query.from(s in Storages.Site,
      where: s.name == ^name,
      join: p in assoc(s, :parameters),
      preload: [parameters: p]
    )
    |> Storages.Repo.all()
  end
end
