defmodule Storages.Repo.Migrations.CreateSiteParams do
  use Ecto.Migration

  def change do
    create table(:site_parameters, primary_key: false) do
      add(:site_id, references(:sites))
      add(:parameter_id, references(:parameters))
    end

    create(
      unique_index(:site_parameters, [:site_id, :parameter_id],
        name: :site_parameters_composite_index
      )
    )
  end
end
