defmodule WingmanFinder.ModuleTest do
  use WingmanFinder.DataCase

  alias WingmanFinder.Module

  import WingmanFinder.Factory

  setup context do
    params =
      params_for(:module, name: context[:name], type: context[:type], sim_id: context[:sim_id])

    changeset = Module.changeset(%Module{}, params)
    [changeset: changeset]
  end

  describe "modules" do
    @tag name: "name", type: "map", sim_id: 1
    test "valid changeset", %{changeset: changeset} do
      assert changeset.valid?
    end

    @tag name: "", type: "map", sim_id: 1
    test "name is required", %{changeset: changeset} do
      refute changeset.valid?
      assert changeset.errors == [name: {"can't be blank", [validation: :required]}]
    end

    @tag name: "name", type: "", sim_id: 1
    test "type is required", %{changeset: changeset} do
      refute changeset.valid?
      assert changeset.errors == [type: {"can't be blank", [validation: :required]}]
    end

    @tag name: "name", type: "map", sim_id: nil
    test "sim_id is required", %{changeset: changeset} do
      refute changeset.valid?
      assert changeset.errors == [sim_id: {"can't be blank", [validation: :required]}]
    end
  end
end
