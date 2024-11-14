defmodule Storages.Repo.Migrations.CreateParams do
  use Ecto.Migration

  def change do
    create table(:parameters) do
      add(:name, :string)
    end

    create(unique_index(:parameters, [:name]))
  end
end
