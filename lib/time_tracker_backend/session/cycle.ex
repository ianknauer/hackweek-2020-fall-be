defmodule TimeTrackerBackend.Session.Cycle do
  use Ecto.Schema
  import Ecto.Changeset
  alias TimeTrackerBackend.Session.Cycle

  schema "cycles" do
    field(:what, :string)
    field(:how, :string)
    field(:hazards, :string)
    field(:energy, :string)
    field(:moral, :string)
    field(:completeness, :string)
    field(:noteworthy, :string)
    field(:distractions, :string)
    field(:improvements, :string)

    belongs_to(:session, TimeTrackerBackend.Session.Session)

    timestamps([:utc_datetime])
  end

  @doc false
  def changeset(%Cycle{} = cycle, attrs) do
    cycle
    |> cast(attrs, [
      :what,
      :how,
      :hazards,
      :energy,
      :moral,
      :completeness,
      :noteworthy,
      :distractions,
      :improvements,
      :session_id
    ])
    |> foreign_key_constraint(:session_id)
  end
end
