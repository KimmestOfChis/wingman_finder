defmodule WingmanFinder.SimContextTest do
  use WingmanFinder.DataCase
  import WingmanFinder.Factory
  alias WingmanFinder.{Sim, SimContext}

  describe "list_sims" do
    test "it lists all sims" do
      insert_pair(:sim)
      sims = SimContext.list_sims()
      assert length(sims) == 2
    end
  end

  describe "get_sim" do
    test "it gets a sim" do
      sim = insert(:sim)

      assert SimContext.get_sim(sim.id) == sim
    end
  end

  describe "create_sim" do
    test "it creates a sim" do
      params = params_for(:sim)
      {:ok, %Sim{} = sim} = SimContext.create_sim(params)

      assert sim.name == params.name
    end

    test "it returns a changset with invalid params" do
      bad_params = params_for(:sim, name: "")

      {:error, %Ecto.Changeset{errors: errors}} = SimContext.create_sim(bad_params)
      assert errors == [name: {"can't be blank", [validation: :required]}]
    end

    test "it does not create duplicates" do
      name = "Taken name"
      insert(:sim, name: name)
      duplicate_params = params_for(:sim, name: name)

      {:error, %Ecto.Changeset{errors: errors}} = SimContext.create_sim(duplicate_params)

      assert errors == [
               name:
                 {"has already been taken",
                  [{:constraint, :unique}, {:constraint_name, "sims_name_index"}]}
             ]
    end
  end

  describe "update_sim" do
    setup do
      sim = insert(:sim)

      [sim: sim]
    end

    test "it updates a sim", %{sim: sim} do
      update_params = params_for(:sim)
      {:ok, %Sim{} = updated_sim} = SimContext.update_sim(sim, update_params)

      assert updated_sim.name == update_params.name
    end

    test "it returns a changset with invalid params", %{sim: sim} do
      bad_params = params_for(:sim, name: "")

      {:error, %Ecto.Changeset{errors: errors}} = SimContext.update_sim(sim, bad_params)
      assert errors == [name: {"can't be blank", [validation: :required]}]
    end

    test "it does not create duplicates", %{sim: sim} do
      name = "Taken name"
      insert(:sim, name: name)
      duplicate_params = params_for(:sim, name: name)

      {:error, %Ecto.Changeset{errors: errors}} = SimContext.update_sim(sim, duplicate_params)

      assert errors == [
               name:
                 {"has already been taken",
                  [{:constraint, :unique}, {:constraint_name, "sims_name_index"}]}
             ]
    end
  end
end
