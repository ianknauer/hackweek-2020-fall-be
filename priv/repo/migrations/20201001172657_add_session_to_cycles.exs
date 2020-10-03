defmodule TimeTrackerBackend.Repo.Migrations.AddSessionToCycles do
  use Ecto.Migration

  def change do
    alter table(:cycles) do
      add(:session_id, references(:sessions, on_delete: :nothing))
    end
  end
end
