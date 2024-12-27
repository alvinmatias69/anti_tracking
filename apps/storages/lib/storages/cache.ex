defmodule Storages.Cache do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def lookup(site_name) do
    GenServer.call(__MODULE__, {:lookup, site_name})
  end

  def add(site_name, parameters) do
    GenServer.cast(__MODULE__, {:add, {site_name, parameters}})
  end

  def update(site_name, parameters) do
    GenServer.cast(__MODULE__, {:update, {site_name, parameters}})
  end

  def reset() do
    GenServer.cast(__MODULE__, {:reset})
  end

  @impl true
  def init(:ok) do
    {:ok, %{}}
  end

  @impl true
  def handle_call({:lookup, site_name}, _from, cache) do
    case Map.fetch(cache, site_name) do
      {:ok, parameters} -> {:reply, MapSet.to_list(parameters), cache}
      _ -> {:reply, [], cache}
    end
  end

  @impl true
  def handle_cast({:add, {site_name, parameters}}, cache) do
    case Map.fetch(cache, site_name) do
      :error ->
        {:noreply, Map.put(cache, site_name, MapSet.new(parameters))}

      {:ok, old_parameters} ->
        {:noreply,
         Map.put(cache, site_name, MapSet.union(old_parameters, MapSet.new(parameters)))}
    end
  end

  @impl true
  def handle_cast({:update, {site_name, parameters}}, cache) do
    case Map.fetch(cache, site_name) do
      :error ->
        {:noreply, cache}

      {:ok, old_parameters} ->
        {:noreply,
         Map.put(cache, site_name, MapSet.union(old_parameters, MapSet.new(parameters)))}
    end
  end

  @impl true
  def handle_cast({:reset}, _cache) do
    {:noreply, %{}}
  end
end
