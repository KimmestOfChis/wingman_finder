defmodule WingmanFinderWeb.ModuleController do
  use WingmanFinderWeb, :controller

  alias WingmanFinder.ModuleContext

  action_fallback WingmanFinderWeb.FallbackController

  def index(conn, _params) do
    modules = ModuleContext.list_modules()

    render(conn, "index.json", modules: modules)
  end

  def show(conn, %{"id" => id}) do
    module = ModuleContext.get_module(id)
    render(conn, "show.json", module: module)
  end

  def create(conn, params) do
    with {:ok, module} <- ModuleContext.create_module(params) do
      conn
      |> put_status(:created)
      |> render("show.json", module: module)
    end
  end

  def update(conn, %{"id" => id} = params) do
    ModuleContext.get_module(id)
    |> ModuleContext.update_module(params)
    |> case do
      {:ok, module} ->
        conn
        |> put_status(:ok)
        |> render("show.json", module: module)

      error ->
        error
    end
  end
end
