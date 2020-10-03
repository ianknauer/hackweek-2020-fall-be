defmodule TimeTrackerBackend.Repo do
  use Ecto.Repo,
    otp_app: :time_tracker_backend,
    adapter: Ecto.Adapters.Postgres
end
