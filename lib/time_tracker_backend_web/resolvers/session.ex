defmodule TimeTrackerBackendWeb.Resolvers.Session do
  alias TimeTrackerBackend.Session.Session

  import IEx

  def sessions(_, _, _) do
    {:ok, Session.list_sessions()}
  end

  def cycles_for_session(session, _, _) do
    query = Ecto.assoc(session, :cycles)
    {:ok, TimeTrackerBackend.Repo.all(query)}
  end

  def create_session(_, %{input: params}, _) do
    case Session.create_session(params) do
      {:error, changeset} ->
        {:ok, %{errors: transform_errors(changeset)}}

      {:ok, session} ->
        TimeTrackerBackend.Timer.ServicesSupervisor.start_worker_for_session(session)
        {:ok, %{session: session}}
    end
  end

  def update_session(_, %{id: id, input: params}, _) do
    session = Session.get_session!(id)

    case Session.update_session(session, params) do
      {:error, changeset} ->
        {:ok, %{errors: transform_errors(changeset)}}

      {:ok, session} ->
        {:ok, %{session: session}}
    end
  end

  def create_cycle(_, %{input: params}, _) do
    case Session.create_cycle(params) do
      {:error, changeset} ->
        {:ok, %{errors: transform_errors(changeset)}}

      {:ok, cycle} ->
        {:ok, %{cycle: cycle}}
    end
  end

  def update_cycle(_, %{id: id, input: params}, _) do
    cycle = Session.get_cycle!(id)

    case Session.update_cycle(cycle, params) do
      {:error, changeset} ->
        {:ok, %{errors: transform_errors(changeset)}}

      {:ok, cycle} ->
        {:ok, %{cycle: cycle}}
    end
  end

  defp transform_errors(changeset) do
    changeset
    |> Ecto.Changeset.traverse_errors(&format_error/1)
    |> Enum.map(fn
      {key, value} ->
        %{key: key, message: value}
    end)
  end

  @spec format_error(Ecto.Changeset.error()) :: String.t()
  defp format_error({msg, opts}) do
    Enum.reduce(opts, msg, fn {key, value}, acc ->
      String.replace(acc, "%{#{key}}", to_string(value))
    end)
  end
end
