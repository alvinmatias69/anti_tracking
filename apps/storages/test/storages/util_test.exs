defmodule Storages.UtilTest do
  use ExUnit.Case, async: true
  doctest Storages.Util

  import Storages.Util

  test "Should strip scheme" do
    assert normalize_url("http://example.com") == "example.com"
  end

  test "Should strip secure scheme" do
    assert normalize_url("https://example.com") == "example.com"
  end

  test "Should strip www subdomain" do
    assert normalize_url("www.example.com") == "example.com"
  end

  test "Should strip scheme and www subdomain" do
    assert normalize_url("http://www.example.com") == "example.com"
  end

  test "Should strip secure scheme and www subdomain" do
    assert normalize_url("https://www.example.com") == "example.com"
  end

  test "Should not strip www in domain" do
    assert normalize_url("examplewww.com") == "examplewww.com"
  end
end
