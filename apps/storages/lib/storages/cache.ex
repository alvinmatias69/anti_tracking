defmodule Storages.Cache do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def lookup(site_name) do
    GenServer.call(__MODULE__, {:lookup, site_name})
  end

  def add({site_name, parameters}) do
    GenServer.cast(__MODULE__, {:add, {site_name, parameters}})
  end

  @impl true
  def init(:ok) do
    {:ok, %{}}
  end

  @impl true
  def handle_call({:lookup, site_name}, _from, cache) do
    case Map.fetch(cache, site_name) do
      {:ok, parameters} -> {:reply, parameters, cache}
      _ -> {:reply, [], cache}
    end
  end

  @impl true
  def handle_cast({:add, {site_name, parameters}}, cache) do
    case Map.fetch(cache, site_name) do
      :error -> {:noreply, Map.put(cache, site_name, parameters)}
      {:ok, old_parameters} -> {:noreply, Map.put(cache, site_name, old_parameters ++ parameters)}
    end
  end
end
