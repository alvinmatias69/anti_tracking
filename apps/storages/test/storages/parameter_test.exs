defmodule Storages.ParameterTest do
  use Storages.RepoCase
  import Storages.TestUtil

  @tag :database
  test "insert_all! should return generated id according to the input" do
    parameters = [%{name: generate_unique_name("a")}, %{name: generate_unique_name("b")}]
    result = Storages.Parameter.insert_all!(parameters)
    assert length(result) == length(parameters)
  end

  @tag :database
  test "get_ids_by_names should return id of name entry" do
    name = generate_unique_name()
    {:ok, result} = insert_parameter(name)

    [id] = Storages.Parameter.get_ids_by_names([name])
    assert id == result.id
  end

  @tag :database
  test "get_id_name_by_names should return only available names" do
    name = generate_unique_name()
    {:ok, param} = insert_parameter(name)

    result = Storages.Parameter.get_id_name_by_names([name])
    assert Map.has_key?(result, name)
    assert Map.get(result, name) == param.id
  end

  @tag :database
  test "get_id_name_by_names should not return unavailable names" do
    name = generate_unique_name()

    result = Storages.Parameter.get_id_name_by_names([name])
    assert !Map.has_key?(result, name)
  end
end
