defmodule Storages.Parameter do
  use Ecto.Schema
  import Ecto.Changeset

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
end
