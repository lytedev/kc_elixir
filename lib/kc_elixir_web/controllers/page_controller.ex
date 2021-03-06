defmodule KcElixirWeb.PageController do
  use KcElixirWeb, :controller

  @meetups [
    %{
      datetime: [
        ~N{2019-04-04 18:00:00},
        ~N{2019-04-04 20:00:00}
      ],
      speaker: %{
        name: "Everyone!"
      },
      topic: "How I Work",
      location: %{
        url: "https://goo.gl/maps/cYJFK7eXG362",
        address: "8500 Shawnee Mission Pkwy Mission, KS 66202",
        venue: "Company Kitchen"
      },
      description: """
      This session will give everybody the opportunity to show off or improve
      their workflows. We'll talk about editors, tools, environments, and all
      the wonderful things that make working with Elixir (or any programming
      language, really) as smooth and awesome as possible.
      """
    }
  ]

  def index(conn, _params) do
    render(conn, "index.html", meetups: Enum.map(@meetups, &englishify/1))
  end

  def englishify(meetup) do
    # [dt_from, dt_to] = meetup.datetime |> Enum.map(&DateTime.from_naive!(&1, "America/Chicago"))
    [dt_from, dt_to] = meetup.datetime |> Enum.map(&DateTime.from_naive!(&1, "Etc/UTC"))

    # TODO: exclude dates from the past?

    dt_from |> IO.inspect()

    from = Timex.format!(dt_from, "{WDfull}, {Mfull} {D}, {YYYY} - {h12}:{m} {AM}")
    to = Timex.format!(dt_to, "{h12}:{m} {AM}")

    meetup
    |> Map.merge(%{
      date_of: Timex.format!(dt_from, "{WDfull}, {Mfull} {D}, {YYYY}"),
      datetime_description: "#{from} to #{to}",
      location_description: "#{meetup.location.venue} - #{meetup.location.address}"
    })
  end
end
