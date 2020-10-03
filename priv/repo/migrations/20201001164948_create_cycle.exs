defmodule TimeTrackerBackend.Repo.Migrations.CreateCycle do
  use Ecto.Migration

  def change do
    create table(:cycles) do
      add :what, :text
      add :how, :text
      add :hazards, :text
      add :energy, :string
      add :moral, :string
      add :completeness, :string
      add :noteworthy, :text
      add :distractions, :text
      add :improvements, :text

      timestamps(type: :utc_datetime)
    end
  end
end
