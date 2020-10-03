defmodule TimeTrackerBackendWeb.Schema do
  use Absinthe.Schema

  alias TimeTrackerBackendWeb.Resolvers

  import_types(__MODULE__.SessionTypes)

  import IEx

  query do
    field :sessions, list_of(:session) do
      resolve(&Resolvers.Session.sessions/3)
    end
  end

  mutation do
    field :create_session, :session_result do
      arg(:input, non_null(:create_session_input))
      resolve(&Resolvers.Session.create_session/3)
    end

    field :update_session, :session_result do
      arg(:id, non_null(:integer))
      arg(:input, non_null(:update_session_input))
      resolve(&Resolvers.Session.update_session/3)
    end

    field :create_cycle, :cycle_result do
      arg(:input, non_null(:create_cycle_input))
      resolve(&Resolvers.Session.create_cycle/3)
    end

    field :update_cycle, :cycle_result do
      arg(:id, non_null(:integer))
      arg(:input, non_null(:update_cycle_input))
      resolve(&Resolvers.Session.update_cycle/3)
    end
  end

  subscription do
    field :status_update, :status do
      config(fn _args, _info ->
        {:ok, topic: "*"}
      end)
    end
  end

  @desc "An error encountered trying to persist input"
  object :input_error do
    field(:key, non_null(:string))
    field(:message, non_null(:string))
  end

  scalar :date do
    parse(fn input ->
      with %Absinthe.Blueprint.Input.String{value: value} <- input,
           {:ok, date} <- Date.from_iso8601(value) do
        {:ok, date}
      else
        _ -> :error
      end
    end)

    serialize(fn date ->
      {:ok, time} = DateTime.from_naive(date, "Etc/UTC")
      DateTime.to_iso8601(time)
    end)
  end
end
