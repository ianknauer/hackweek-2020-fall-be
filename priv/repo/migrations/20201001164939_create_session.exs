defmodule TimeTrackerBackend.Repo.Migrations.CreateSession do
  use Ecto.Migration

  def change do
    create table(:sessions) do
      add :start_time, :utc_datetime, null: false
      add :length_of_cycle, :integer, null: false
      add :length_of_break, :integer, null: false
      add :total_cycles, :integer, null: false
      add :goal, :text
      add :reason, :text
      add :completeness, :text
      add :measurable, :text
      add :other, :text
      add :end_accomplishment, :text
      add :end_comparison, :text
      add :end_stuck, :text
      add :end_success, :text
      add :end_learning, :text

      timestamps(type: :utc_datetime)
    end
  end
end
