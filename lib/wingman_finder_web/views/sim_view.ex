defmodule WingmanFinderWeb.SimView do
  use WingmanFinderWeb, :view

  def render("index.json", %{sims: sims}) do
    %{data: render_many(sims, __MODULE__, "sim.json")}
  end

  def render("show.json", %{sim: sim}) do
    %{data: render_one(sim, __MODULE__, "sim.json")}
  end

  def render("sim.json", %{sim: sim}) do
    %{id: sim.id, name: sim.name}
  end

  def render("error.json", %{errors: errors}) do
    %{errors: errors}
  end
end
