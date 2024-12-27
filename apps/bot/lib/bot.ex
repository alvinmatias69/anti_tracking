defmodule Bot do
  use WebSockex
  require Logger

  def start_link(opts \\ []) do
    WebSockex.start_link(Keyword.get(opts, :url), __MODULE__, :state, opts)
  end

  @spec cast_message(String.t()) :: :ok
  def cast_message(message) do
    Logger.info("casting message: #{message}")
    WebSockex.cast(__MODULE__, message)
  end

  def handle_connect(_conn, state) do
    Logger.info("connected successfuly!")
    {:ok, state}
  end

  def handle_frame({:text, "success connecting with id: " <> bot_id}, state) do
    Logger.info("assigned id #{bot_id}")
    {:ok, state}
  end

  def handle_frame({:text, message}, state) do
    Task.Supervisor.start_child(Bot.TaskSupervisor, Bot.MessageHandler, :handle, [message])
    {:ok, state}
  end

  def handle_disconnect(%{reason: {:local, reason}}, state) do
    Logger.info("Local close with reason: #{inspect(reason)}")
    {:ok, state}
  end

  def handle_disconnect(disconnect_map, state) do
    super(disconnect_map, state)
  end

  def handle_cast(message, state) do
    {:reply, {:text, message}, state}
  end
end
