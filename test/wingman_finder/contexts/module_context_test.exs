defmodule WingmanFinder.ModuleContextTest do
  use WingmanFinder.DataCase
  import WingmanFinder.Factory
  alias WingmanFinder.{Module, ModuleContext}

  describe "list_modules" do
    test "it lists all modules" do
      insert_pair(:module)
      modules = ModuleContext.list_modules()
      assert length(modules) == 2
    end
  end

  describe "get_module" do
    test "it gets a module" do
      module = insert(:module)

      assert ModuleContext.get_module(module.id) |> Repo.preload(:sim) == module
    end
  end

  describe "create_module" do
    setup do
      sim = insert(:sim)

      [sim: sim]
    end

    test "it creates a module", %{sim: sim} do
      params = params_for(:module, sim_id: sim.id)
      {:ok, %Module{} = module} = ModuleContext.create_module(params)

      assert module.name == params.name
    end

    test "it returns a changset with invalid params", %{sim: sim} do
      bad_params = params_for(:module, name: "", sim_id: sim.id)

      {:error, %Ecto.Changeset{errors: errors}} = ModuleContext.create_module(bad_params)
      assert errors == [name: {"can't be blank", [validation: :required]}]
    end

    test "it does not create duplicates", %{sim: sim} do
      name = "Taken name"
      insert(:module, name: name)
      duplicate_params = params_for(:module, name: name, sim_id: sim.id)

      {:error, %Ecto.Changeset{errors: errors}} = ModuleContext.create_module(duplicate_params)

      assert errors == [
               name:
                 {"has already been taken",
                  [{:constraint, :unique}, {:constraint_name, "modules_name_index"}]}
             ]
    end
  end

  describe "update_module" do
    setup do
      module = insert(:module)

      [module: module]
    end

    test "it updates a module", %{module: module} do
      update_params = params_for(:module)
      {:ok, %Module{} = updated_module} = ModuleContext.update_module(module, update_params)

      assert updated_module.name == update_params.name
    end

    test "it returns a changset with invalid params", %{module: module} do
      bad_params = params_for(:module, name: "")

      {:error, %Ecto.Changeset{errors: errors}} = ModuleContext.update_module(module, bad_params)
      assert errors == [name: {"can't be blank", [validation: :required]}]
    end

    test "it does not create duplicates", %{module: module} do
      name = "Taken name"
      insert(:module, name: name)
      duplicate_params = params_for(:module, name: name)

      {:error, %Ecto.Changeset{errors: errors}} =
        ModuleContext.update_module(module, duplicate_params)

      assert errors == [
               name:
                 {"has already been taken",
                  [{:constraint, :unique}, {:constraint_name, "modules_name_index"}]}
             ]
    end
  end
end
