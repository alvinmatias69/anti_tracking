defmodule Storages.SiteParameterTest do
  use Storages.RepoCase
  import Storages.TestUtil
  import Ecto.Query

  @tag :database
  test "insert_all should successfully insert data" do
    {:ok, param_1} = insert_parameter(generate_unique_name("param_1"))
    {:ok, param_2} = insert_parameter(generate_unique_name("param_2"))
    {:ok, site} = insert_site(generate_unique_name("site"))

    Storages.SiteParameter.insert_all([
      %{parameter_id: param_1.id, site_id: site.id},
      %{parameter_id: param_2.id, site_id: site.id}
    ])

    result =
      Storages.SiteParameter
      |> where([sp], sp.site_id == ^site.id)
      |> Storages.Repo.all()

    assert length(result) == 2
  end

  @tag :database
  test "delete should delete all site occurence" do
    {:ok, param_1} = insert_parameter(generate_unique_name("param_1"))
    {:ok, param_2} = insert_parameter(generate_unique_name("param_2"))
    {:ok, site} = insert_site(generate_unique_name("site"))

    Storages.SiteParameter.insert_all([
      %{parameter_id: param_1.id, site_id: site.id},
      %{parameter_id: param_2.id, site_id: site.id}
    ])

    Storages.SiteParameter.delete(site.id, [])

    result =
      Storages.SiteParameter
      |> where([sp], sp.site_id == ^site.id)
      |> Storages.Repo.all()

    assert length(result) == 0
  end

  @tag :database
  test "delete should delete all parameter occurence" do
    {:ok, param} = insert_parameter(generate_unique_name("param"))
    {:ok, site_1} = insert_site(generate_unique_name("site_1"))
    {:ok, site_2} = insert_site(generate_unique_name("site_2"))

    Storages.SiteParameter.insert_all([
      %{parameter_id: param.id, site_id: site_1.id},
      %{parameter_id: param.id, site_id: site_2.id}
    ])

    Storages.SiteParameter.delete(nil, [param.id])

    result =
      Storages.SiteParameter
      |> where([sp], sp.parameter_id == ^param.id)
      |> Storages.Repo.all()

    assert length(result) == 0
  end

  @tag :database
  test "delete should delete only linked occurence" do
    {:ok, param_1} = insert_parameter(generate_unique_name("param_1"))
    {:ok, param_2} = insert_parameter(generate_unique_name("param_2"))
    {:ok, site_1} = insert_site(generate_unique_name("site_1"))
    {:ok, site_2} = insert_site(generate_unique_name("site_2"))

    Storages.SiteParameter.insert_all([
      %{parameter_id: param_1.id, site_id: site_1.id},
      %{parameter_id: param_1.id, site_id: site_2.id},
      %{parameter_id: param_2.id, site_id: site_1.id},
      %{parameter_id: param_2.id, site_id: site_2.id}
    ])

    Storages.SiteParameter.delete(site_1.id, [param_1.id, param_2.id])

    result =
      Storages.SiteParameter
      |> where([sp], sp.site_id == ^site_1.id)
      |> Storages.Repo.all()

    assert length(result) == 0

    result =
      Storages.SiteParameter
      |> where([sp], sp.site_id == ^site_2.id)
      |> Storages.Repo.all()

    assert length(result) == 2
  end
end
