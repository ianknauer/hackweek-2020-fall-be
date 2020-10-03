defmodule TimeTrackerBackend.Repo.Migrations.AddDefaultToSession do
  use Ecto.Migration

  def change do
    alter table(:sessions) do
      modify :start_time, :utc_datetime, null: false, default: fragment("NOW()")
    end
  end
end
