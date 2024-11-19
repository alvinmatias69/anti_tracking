defmodule Storages.Parameter do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  schema "parameters" do
    field(:name, :string)
    many_to_many(:sites, Storages.Site, join_through: "site_parameters")
  end

  def changeset(parameter, params \\ %{}) do
    parameter
    |> cast(params, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end

  def get_ids_by_names([]), do: []

  def get_ids_by_names(names) do
    Storages.Parameter
    |> where([p], p.name in ^names)
    |> select([p], p.id)
    |> Storages.Repo.all()
  end
end
