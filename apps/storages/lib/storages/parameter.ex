defmodule Storages.Parameter do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  schema "parameters" do
    field(:name, :string)
    many_to_many(:sites, Storages.Site, join_through: "site_parameters")
  end

  @spec changeset(%Storages.Parameter{}, map()) :: %Ecto.Changeset{}
  def changeset(parameter, params \\ %{}) do
    parameter
    |> cast(params, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end

  @spec get_id_name_by_names([]) :: map()
  def get_id_name_by_names([]), do: %{}

  @spec get_id_name_by_names([String.t()]) :: map()
  def get_id_name_by_names(names) do
    Storages.Parameter
    |> where([p], p.name in ^names)
    |> select([p], {p.name, p.id})
    |> Storages.Repo.all()
    |> Enum.into(%{})
  end

  @spec get_ids_by_names([]) :: []
  def get_ids_by_names([]), do: []

  @spec get_ids_by_names([String.t()]) :: [integer()]
  def get_ids_by_names(names) do
    Storages.Parameter
    |> where([p], p.name in ^names)
    |> select([p], p.id)
    |> Storages.Repo.all()
  end

  @spec insert_all!([%{name: String.t()}] | Ecto.Query.t()) :: [integer()]
  def insert_all!(payload) do
    Storages.Parameter
    |> Storages.Repo.insert_all(payload, returning: [:id])
    |> elem(1)
    |> Enum.map(&Map.get(&1, :id))
  end
end
