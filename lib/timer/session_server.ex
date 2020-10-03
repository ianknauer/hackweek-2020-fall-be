defmodule TimeTrackerBackend.Timer.SessionServer do
  @name :session_server
  @refresh_interval :timer.seconds(5)

  use GenServer

  defmodule State do
    defstruct current_cycle: 0,
              start_time: nil,
              max_cycle: nil,
              time_remaining: nil,
              cycle_length: 290,
              break_length: 50,
              status: nil,
              session_id: nil
  end

  def start_link(session) do
    GenServer.start_link(
      __MODULE__,
      %State{
        max_cycle: session.total_cycles,
        start_time: session.start_time,
        session_id: session.id
      }
    )
  end

  def init(initial_state) do
    state = %{
      initial_state
      | status: "active",
        current_cycle: 1,
        time_remaining: initial_state.cycle_length
    }

    schedule_timer()
    {:ok, state}
  end

  def handle_info(:update_state, state) do
    Absinthe.Subscription.publish(TimeTrackerBackendWeb.Endpoint, state, status_update: "*")
    new_state = update(state)
    {:noreply, new_state}
  end

  def schedule_timer do
    Process.send_after(self(), :update_state, @refresh_interval)
  end

  defp update(
         %{
           time_remaining: time_remaining,
           status: status
         } = state
       )
       when time_remaining > 0 and status == "active" do
    new_state = %{state | time_remaining: time_remaining - 10}
    schedule_timer()
    new_state
  end

  defp update(
         %{
           time_remaining: time_remaining,
           current_cycle: current_cycle,
           max_cycle: max_cycle,
           status: status
         } = state
       )
       when time_remaining == 0 and status == "active" and current_cycle <= max_cycle do
    new_state = %{
      state
      | time_remaining: state.break_length,
        status: "break",
        current_cycle: current_cycle + 1
    }

    schedule_timer()
    new_state
  end

  defp update(
         %{
           time_remaining: time_remaining,
           current_cycle: current_cycle,
           max_cycle: max_cycle,
           status: status
         } = state
       )
       when current_cycle > max_cycle do
    new_state = %{state | status: "finished"}
    Absinthe.Subscription.publish(TimeTrackerBackendWeb.Endpoint, new_state, status_update: "*")
    new_state
  end

  defp update(
         %{
           time_remaining: time_remaining,
           status: status
         } = state
       )
       when time_remaining > 0 and status == "break" do
    new_state = %{state | time_remaining: state.time_remaining - 10, status: "break"}
    schedule_timer()
    new_state
  end

  defp update(
         %{
           time_remaining: time_remaining,
           status: status
         } = state
       )
       when time_remaining == 0 and status == "break" do
    new_state = %{state | time_remaining: state.cycle_length, status: "active"}
    schedule_timer()
    new_state
  end
end
