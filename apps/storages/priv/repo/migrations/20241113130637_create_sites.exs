defmodule Storages.Repo.Migrations.CreateSites do
  use Ecto.Migration

  def change do
    create table(:sites) do
      add(:name, :string)
    end

    create(unique_index(:sites, [:name]))
  end
end
