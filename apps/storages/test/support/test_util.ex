defmodule Storages.TestUtil do
  defp prefix(), do: "name_"

  def generate_unique_name(suffix \\ "") do
    now =
      DateTime.utc_now()
      |> DateTime.to_unix()
      |> Integer.to_string()

    prefix() <> now <> suffix
  end

  def insert_parameter(name) do
    insert(%Storages.Parameter{}, Storages.Parameter, name)
  end

  def insert_site(name) do
    insert(%Storages.Site{}, Storages.Site, name)
  end

  defp insert(struct, module, name) do
    struct
    |> module.changeset(%{name: name})
    |> Storages.Repo.insert()
  end
end
