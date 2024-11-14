defmodule Storages.Site do
  use Ecto.Schema
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
end
