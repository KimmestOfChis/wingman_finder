defmodule WingmanFinderWeb.SimControllerTest do
  use WingmanFinderWeb.ConnCase
  import WingmanFinder.Factory

  alias WingmanFinder.{Repo, Sim}

  describe "/index" do
    test "it displays an empty list", %{conn: conn} do
      %Plug.Conn{resp_body: resp_body} = get(conn, Routes.sim_path(conn, :index))
      {:ok, resp_body} = Jason.decode(resp_body)
      assert resp_body == %{"data" => []}
    end

    test "it displays a list of results", %{conn: conn} do
      insert_pair(:sim)

      %Plug.Conn{resp_body: resp_body} = get(conn, Routes.sim_path(conn, :index))
      {:ok, %{"data" => resp_body_list}} = Jason.decode(resp_body)

      assert length(resp_body_list) == 2
    end
  end

  describe "/show" do
    test "it renders a sim", %{conn: conn} do
      sim = insert(:sim)
      %Plug.Conn{resp_body: resp_body} = get(conn, Routes.sim_path(conn, :show, sim.id))

      {:ok, resp_body} = Jason.decode(resp_body)
      assert resp_body == %{"data" => %{"id" => sim.id, "name" => sim.name}}
    end
  end

  describe "/create" do
    test "it creates a sim record", %{conn: conn} do
      sim_params = params_for(:sim)

      %Plug.Conn{resp_body: resp_body} = post(conn, Routes.sim_path(conn, :create), sim_params)

      {:ok, response} = Jason.decode(resp_body)

      %Sim{name: name, id: id} = Repo.get_by(Sim, name: sim_params.name)

      assert response == %{"data" => %{"name" => name, "id" => id}}
    end

    test "it doesn't create duplicate records", %{conn: conn} do
      name = "Some Name"
      insert(:sim, name: name)
      sim_params = params_for(:sim, name: name)

      %Plug.Conn{resp_body: resp_body} = post(conn, Routes.sim_path(conn, :create), sim_params)

      {:ok, response} = Jason.decode(resp_body)

      assert response == %{"errors" => ["name has already been taken"]}
    end

    test "it doesn't create blank records", %{conn: conn} do
      name = ""
      insert(:sim, name: name)
      sim_params = params_for(:sim, name: name)

      %Plug.Conn{resp_body: resp_body} = post(conn, Routes.sim_path(conn, :create), sim_params)

      {:ok, response} = Jason.decode(resp_body)

      assert response == %{"errors" => ["name can't be blank"]}
    end
  end

  describe "/update" do
    setup do
      name = "To be updated"
      sim = insert(:sim, name: name)

      [name: name, sim: sim]
    end

    test "it updates a sim record", %{conn: conn, sim: sim} do
      updated_name = "New Name!"
      sim_params = params_for(:sim, name: updated_name)

      %Plug.Conn{resp_body: resp_body} =
        patch(conn, Routes.sim_path(conn, :update, sim.id), sim_params)

      {:ok, response} = Jason.decode(resp_body)

      assert response == %{"data" => %{"name" => updated_name, "id" => sim.id}}
    end

    test "it doesn't update with a taken name", %{conn: conn, sim: sim} do
      name = "test name"
      insert(:sim, name: name)
      sim_params = params_for(:sim, name: name)

      %Plug.Conn{resp_body: resp_body} =
        put(conn, Routes.sim_path(conn, :update, sim.id), sim_params)

      {:ok, response} = Jason.decode(resp_body)

      assert response == %{"errors" => ["name has already been taken"]}
    end

    test "it doesn't update to blank name", %{conn: conn, sim: sim} do
      name = ""
      sim_params = params_for(:sim, name: name)

      %Plug.Conn{resp_body: resp_body} =
        put(conn, Routes.sim_path(conn, :update, sim.id), sim_params)

      {:ok, response} = Jason.decode(resp_body)

      assert response == %{"errors" => ["name can't be blank"]}
    end
  end
end
