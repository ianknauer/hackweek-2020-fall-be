defmodule TimeTrackerBackendWeb.Schema.SessionTypes do
  use Absinthe.Schema.Notation

  alias TimeTrackerBackendWeb.Resolvers

  @desc "The session is the longer running, add better descriptions"
  object :session do
    field(:id, :id)
    field(:start_time, :date)
    field(:length_of_break, :integer)
    field(:length_of_cycle, :integer)
    field(:total_cycles, :integer)
    field(:goal, :string)
    field(:reason, :string)
    field(:completeness, :string)
    field(:other, :string)
    field(:measurable, :string)
    field(:end_accomplishment, :string)
    field(:end_comparison, :string)
    field(:end_stuck, :string)
    field(:end_success, :string)
    field(:end_learning, :string)
    field(:inserted_at, :date)

    field :cycles, list_of(:cycle) do
      resolve(&Resolvers.Session.cycles_for_session/3)
    end
  end

  @desc "the cycle is the cycle, add better descriptions"
  object :cycle do
    field(:id, :id)
    field(:how, :string)
    field(:what, :string)
    field(:hazards, :string)
    field(:energy, :string)
    field(:moral, :string)
    field(:completeness, :string)
    field(:noteworthy, :string)
    field(:distractions, :string)
    field(:improvements, :string)
  end

  input_object :create_cycle_input do
    field(:how, :string)
    field(:what, :string)
    field(:hazards, :string)
    field(:energy, :string)
    field(:moral, :string)
    field(:completeness, :string)
    field(:noteworthy, :string)
    field(:distractions, :string)
    field(:improvements, :string)
    field(:session_id, non_null(:id))
  end

  input_object :update_cycle_input do
    field(:how, :string)
    field(:what, :string)
    field(:hazards, :string)
    field(:energy, :string)
    field(:moral, :string)
    field(:completeness, :string)
    field(:noteworthy, :string)
    field(:distractions, :string)
    field(:improvements, :string)
  end

  input_object :create_session_input do
    field(:length_of_break, :integer)
    field(:length_of_cycle, :integer)
    field(:total_cycles, :integer)
    field(:goal, :string)
    field(:reason, :string)
    field(:completeness, :string)
    field(:measurable, :string)
    field(:other, :string)
  end

  input_object :update_session_input do
    field(:end_accomplishment, :string)
    field(:end_comparison, :string)
    field(:end_stuck, :string)
    field(:end_success, :string)
    field(:end_learning, :string)
  end

  object :session_result do
    field(:session, :session)
    field(:errors, list_of(:input_error))
  end

  object :cycle_result do
    field(:cycle, :cycle)
    field(:errors, list_of(:input_error))
  end

  object :status do
    field(:current_cycle, :integer)
    field(:max_cycle, :integer)
    field(:time_remaining, :integer)
    field(:cycle_length, :integer)
    field(:break_length, :integer)
    field(:status, :string)
    field(:current_cycle, :integer)
    field(:session_id, :id)
  end
end
