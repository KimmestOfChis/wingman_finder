defmodule WingmanFinderWeb.ModuleView do
  use WingmanFinderWeb, :view

  def render("index.json", %{modules: modules}) do
    %{data: render_many(modules, __MODULE__, "module.json")}
  end

  def render("show.json", %{module: module}) do
    %{data: render_one(module, __MODULE__, "module.json")}
  end

  def render("module.json", %{module: module}) do
    %{id: module.id, name: module.name}
  end

  def render("error.json", %{errors: errors}) do
    %{errors: errors}
  end
end
