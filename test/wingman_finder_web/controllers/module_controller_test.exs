defmodule WingmanFinderWeb.ModuleControllerTest do
  use WingmanFinderWeb.ConnCase
  import WingmanFinder.Factory

  alias WingmanFinder.{Repo, Module}

  describe "/index" do
    test "it displays an empty list", %{conn: conn} do
      %Plug.Conn{resp_body: resp_body} = get(conn, Routes.module_path(conn, :index))
      {:ok, resp_body} = Jason.decode(resp_body)
      assert resp_body == %{"data" => []}
    end

    test "it displays a list of results", %{conn: conn} do
      insert_pair(:module)

      %Plug.Conn{resp_body: resp_body} = get(conn, Routes.module_path(conn, :index))
      {:ok, %{"data" => resp_body_list}} = Jason.decode(resp_body)

      assert length(resp_body_list) == 2
    end
  end

  describe "/show" do
    test "it renders a module", %{conn: conn} do
      module = insert(:module)
      %Plug.Conn{resp_body: resp_body} = get(conn, Routes.module_path(conn, :show, module.id))

      {:ok, resp_body} = Jason.decode(resp_body)
      assert resp_body == %{"data" => %{"id" => module.id, "name" => module.name}}
    end
  end

  describe "/create" do
    setup do
      sim = insert(:sim)

      [sim: sim]
    end

    test "it creates a module record", %{conn: conn, sim: sim} do
      module_params = params_for(:module, sim: sim)

      %Plug.Conn{resp_body: resp_body} =
        post(conn, Routes.module_path(conn, :create), module_params)

      {:ok, response} = Jason.decode(resp_body)

      %Module{name: name, id: id} = Repo.get_by(Module, name: module_params.name)

      assert response == %{"data" => %{"name" => name, "id" => id}}
    end

    test "it doesn't create duplicate records", %{conn: conn, sim: sim} do
      name = "Some Name"
      insert(:module, name: name, sim: sim)
      module_params = params_for(:module, name: name, sim_id: sim.id)

      %Plug.Conn{resp_body: resp_body} =
        post(conn, Routes.module_path(conn, :create), module_params)

      {:ok, response} = Jason.decode(resp_body)

      assert response == %{"errors" => "has already been taken"}
    end

    test "it doesn't create blank records", %{conn: conn, sim: sim} do
      name = ""
      insert(:module, name: name, sim: sim)
      module_params = params_for(:module, name: name, sim_id: sim.id)

      %Plug.Conn{resp_body: resp_body} =
        post(conn, Routes.module_path(conn, :create), module_params)

      {:ok, response} = Jason.decode(resp_body)

      assert response == %{"errors" => "can't be blank"}
    end

    test "it requires a sim_id", %{conn: conn, sim: sim} do
      insert(:module, sim: sim)
      module_params = params_for(:module, sim_id: nil)

      %Plug.Conn{resp_body: resp_body} =
        post(conn, Routes.module_path(conn, :create), module_params)

      {:ok, response} = Jason.decode(resp_body)

      assert response == %{"errors" => "can't be blank"}
    end
  end

  describe "/update" do
    setup do
      name = "To be updated"
      module = insert(:module, name: name)

      [name: name, module: module]
    end

    test "it updates a module record", %{conn: conn, module: module} do
      updated_name = "New Name!"
      module_params = params_for(:module, name: updated_name)

      %Plug.Conn{resp_body: resp_body} =
        patch(conn, Routes.module_path(conn, :update, module.id), module_params)

      {:ok, response} = Jason.decode(resp_body)

      assert response == %{"data" => %{"name" => updated_name, "id" => module.id}}
    end

    test "it doesn't update with a taken name", %{conn: conn, module: module} do
      name = "test name"
      insert(:module, name: name)
      module_params = params_for(:module, name: name)

      %Plug.Conn{resp_body: resp_body} =
        put(conn, Routes.module_path(conn, :update, module.id), module_params)

      {:ok, response} = Jason.decode(resp_body)

      assert response == %{"errors" => "has already been taken"}
    end

    test "it doesn't update to blank name", %{conn: conn, module: module} do
      name = ""
      module_params = params_for(:module, name: name)

      %Plug.Conn{resp_body: resp_body} =
        put(conn, Routes.module_path(conn, :update, module.id), module_params)

      {:ok, response} = Jason.decode(resp_body)

      assert response == %{"errors" => "can't be blank"}
    end
  end
end
