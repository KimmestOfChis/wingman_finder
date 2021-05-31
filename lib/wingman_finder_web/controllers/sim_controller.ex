defmodule WingmanFinderWeb.SimController do
  use WingmanFinderWeb, :controller

  alias WingmanFinder.{Repo, Sim, SimContext}

  def index(conn, _params) do
    sims = SimContext.list_sims()

    render(conn, "index.json", sims: sims)
  end

  def show(conn, %{"id" => id}) do
    sim = SimContext.get_sim(id)
    render(conn, "show.json", sim: sim)
  end

  def create(conn, params) do
    params
    |> SimContext.create_sim()
    |> case do
      {:ok, sim} ->
        conn
        |> put_status(:created)
        |> render("show.json", sim: sim)

      {:error, changeset} ->
        error_handler(conn, changeset)
    end
  end

  def update(conn, %{"id" => id} = params) do
    Sim
    |> Repo.get(id)
    |> SimContext.update_sim(params)
    |> case do
      {:ok, sim} ->
        conn
        |> put_status(:created)
        |> render("show.json", sim: sim)

      {:error, changeset} ->
        error_handler(conn, changeset)
    end
  end

  defp error_handler(conn, %Ecto.Changeset{errors: [name: {error_reason, _}]}) do
    render(conn, "error.json", error: error_reason)
  end
end
