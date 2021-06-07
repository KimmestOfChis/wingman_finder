defmodule WingmanFinderWeb.SimController do
  use WingmanFinderWeb, :controller

  alias WingmanFinder.SimContext

  action_fallback WingmanFinderWeb.FallbackController

  def index(conn, _params) do
    sims = SimContext.list_sims()

    render(conn, "index.json", sims: sims)
  end

  def show(conn, %{"id" => id}) do
    sim = SimContext.get_sim(id)
    render(conn, "show.json", sim: sim)
  end

  def create(conn, params) do
    with {:ok, sim} <- SimContext.create_sim(params) do
      conn
      |> put_status(:created)
      |> render("show.json", sim: sim)
    end
  end

  def update(conn, %{"id" => id} = params) do
    SimContext.get_sim(id)
    |> SimContext.update_sim(params)
    |> case do
      {:ok, sim} ->
        conn
        |> put_status(:ok)
        |> render("show.json", sim: sim)

      error ->
        error
    end
  end
end
