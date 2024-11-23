defmodule Storages.SiteTest do
  use Storages.RepoCase
  import Storages.TestUtil

  @tag :database
  test "get_id_by_name should return nil when not found" do
    assert Storages.Site.get_id_by_name("not_existing") == nil
  end

  @tag :database
  test "get_id_by_name should return id when found" do
    name = generate_unique_name()
    {:ok, result} = insert_site(name)

    assert Storages.Site.get_id_by_name(name) == result.id
  end

  @tag :database
  test "get_with_parameters should return nil when not found" do
    assert Storages.Site.get_with_parameters("not_existing") == nil
  end

  @tag :database
  test "get_with_parameters should return empty parameters on site without parameters" do
    name = generate_unique_name()
    {:ok, _} = insert_site(name)

    %{parameters: parameters} = Storages.Site.get_with_parameters(name)

    assert parameters == []
  end

  @tag :database
  test "get_with_parameters should return parameters when found" do
    name = generate_unique_name()

    parameters = [
      %Storages.Parameter{
        name: generate_unique_name()
      }
    ]

    {:ok, _} =
      %Storages.Site{
        name: name,
        parameters: parameters
      }
      |> Storages.Repo.insert()

    %{parameters: result_parameters} = Storages.Site.get_with_parameters(name)
    assert List.first(result_parameters).name == List.first(parameters).name
  end

  @tag :database
  test "get_or_insert should return available id" do
    name = generate_unique_name()
    {:ok, result} = insert_site(name)

    {:ok, id} = Storages.Site.get_or_insert(name)
    assert id == result.id
  end

  @tag :database
  test "get_or_insert should insert when unavailable" do
    name = generate_unique_name()
    {:ok, result_id} = Storages.Site.get_or_insert(name)

    id =
      Storages.Repo.get_by(Storages.Site, name: name)
      |> case do
        nil ->
          nil

        result ->
          result.id
      end

    assert id == result_id
  end
end
