defmodule TimeTrackerBackend.Session.Session do
  use Ecto.Schema
  import Ecto.Changeset
  alias TimeTrackerBackend.Session.Session
  alias TimeTrackerBackend.Session.Cycle

  schema "sessions" do
    field(:start_time, :utc_datetime, read_after_writes: true)
    field(:length_of_cycle, :integer, default: 40)
    field(:length_of_break, :integer, default: 10)
    field(:total_cycles, :integer)
    field(:goal, :string)
    field(:reason, :string)
    field(:completeness, :string)
    field(:measurable, :string)
    field(:other, :string)
    field(:end_accomplishment, :string)
    field(:end_comparison, :string)
    field(:end_stuck, :string)
    field(:end_success, :string)
    field(:end_learning, :string)

    has_many :cycles, Cycle

    timestamps([:utc_datetime])
  end

  @doc false
  def changeset(%Session{} = session, attrs) do
    session
    |> cast(attrs, [
      :length_of_cycle,
      :length_of_break,
      :total_cycles,
      :goal,
      :reason,
      :completeness,
      :measurable,
      :end_accomplishment,
      :end_comparison,
      :end_stuck,
      :end_success,
      :end_learning
    ])
    |> validate_required([:total_cycles])
  end

  alias TimeTrackerBackend.Repo

  import Ecto.Query, warn: false

  def get_session!(id), do: Repo.get!(Session, id)

  def list_sessions do
    Repo.all(Session)
  end

  def create_session(attrs \\ %{}) do
    %Session{}
    |> Session.changeset(attrs)
    |> Repo.insert()
  end

  def update_session(%Session{} = session, attrs) do
    session
    |> Session.changeset(attrs)
    |> Repo.update()
  end

  def get_cycle!(id), do: Repo.get!(Cycle, id)

  def create_cycle(attrs \\ %{}) do
    %Cycle{}
    |> Cycle.changeset(attrs)
    |> Repo.insert()
  end

  def update_cycle(%Cycle{} = cycle, attrs) do
    cycle
    |> Cycle.changeset(attrs)
    |> Repo.update()
  end
end
