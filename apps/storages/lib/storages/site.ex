defmodule Storages.Site do
  use Ecto.Schema
  require Ecto.Query
  import Ecto.Changeset
  import Ecto.Query

  schema "sites" do
    field(:name, :string)
    many_to_many(:parameters, Storages.Parameter, join_through: "site_parameters")
  end

  @spec changeset(%Storages.Site{}, map()) :: %Ecto.Changeset{}
  def changeset(site, params \\ %{}) do
    site
    |> cast(params, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end

  @spec get_or_insert(String.t()) :: {:error, %Ecto.Changeset{}} | {:ok, integer()}
  def get_or_insert(name) do
    case get_id_by_name(name) do
      nil ->
        %Storages.Site{}
        |> Storages.Site.changeset(%{name: name})
        |> Storages.Repo.insert()
        |> case do
          {:ok, result} ->
            {:ok, result.id}

          err ->
            err
        end

      id ->
        {:ok, id}
    end
  end

  @spec get_with_parameters(String.t()) :: %Storages.Site{} | nil
  def get_with_parameters(name) do
    from(s in Storages.Site,
      where: s.name == ^name,
      left_join: p in assoc(s, :parameters),
      preload: [parameters: p]
    )
    |> Storages.Repo.one()
  end

  @spec get_id_by_name(<<>>) :: nil
  def get_id_by_name(""), do: nil

  @spec get_id_by_name(String.t()) :: integer() | nil
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
