defmodule TimeTrackerBackend.Timer.ServicesSupervisor do
  use DynamicSupervisor

  def start_link([]) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_worker_for_session(session) do
    DynamicSupervisor.start_child(
      __MODULE__,
      {TimeTrackerBackend.Timer.SessionServer, session}
    )
  end
end
