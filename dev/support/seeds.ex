defmodule TimeTrackerBackend.Seeds do
  def run() do
    alias TimeTrackerBackend.{Session, Repo}

    session =
      %Session.Session{
        start_time: DateTime.from_naive!(~N[2020-10-01 13:26:08], "Etc/UTC"),
        length_of_cycle: 30,
        length_of_break: 10,
        total_cycles: 7,
        goal: "Finish up the elixir half of this app before the end of the day!",
        reason: "I need to finish this so i can get back to the front end application",
        completeness: "I'll be able to interact with everything as needed through graphiQL",
        measurable: "Yes, though I could probably be more specific in what needs to be done"
      }
      |> Repo.insert!()

    first_cycle =
      %Session.Cycle{
        what: "build up the seeds and schemas",
        how: "Look up documentation, start building migrations",
        hazards: "early in the morning, need caffeine",
        energy: "low",
        moral: "medium",
        completeness: "yes",
        noteworthy: "Managed to create both migrations, think through the models",
        distractions: "Twitter",
        improvements: "Put phone on the other side of the room",
        session: session
      }
      |> Repo.insert!()

    second_cycle =
      %Session.Cycle{
        what: "add relationships between cycles, start working on create/list/get functions",
        how: "run migration for adding relationships",
        hazards: "phone",
        energy: "medium",
        moral: "high",
        session: session
      }
      |> Repo.insert!()
  end
end
