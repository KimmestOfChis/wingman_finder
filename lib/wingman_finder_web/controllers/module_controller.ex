defmodule WingmanFinderWeb.ModuleController do
  use WingmanFinderWeb, :controller

  alias WingmanFinder.{Module, ModuleContext, Repo}

  def index(conn, _params) do
    modules = ModuleContext.list_modules()

    render(conn, "index.json", modules: modules)
  end

  def show(conn, %{"id" => id}) do
    module = ModuleContext.get_module(id)
    render(conn, "show.json", module: module)
  end

  def create(conn, params) do
    params
    |> ModuleContext.create_module()
    |> case do
      {:ok, module} ->
        conn
        |> put_status(:created)
        |> render("show.json", module: module)

      {:error, changeset} ->
        error_handler(conn, changeset)
    end
  end

  def update(conn, %{"id" => id} = params) do
    Module
    |> Repo.get(id)
    |> ModuleContext.update_module(params)
    |> case do
      {:ok, module} ->
        conn
        |> put_status(:created)
        |> render("show.json", module: module)

      {:error, changeset} ->
        error_handler(conn, changeset)
    end
  end

  defp error_handler(conn, %Ecto.Changeset{errors: [name: {error_reason, _}]}) do
    render(conn, "error.json", error: error_reason)
  end

  defp error_handler(conn, %Ecto.Changeset{errors: [sim_id: {error_reason, _}]}) do
    render(conn, "error.json", error: error_reason)
  end
end
