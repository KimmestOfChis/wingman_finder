defmodule WingmanFinder.SimTest do
  use WingmanFinder.DataCase

  alias WingmanFinder.Sim

  import WingmanFinder.Factory

  setup context do
    params = params_for(:sim, name: context[:name])

    changeset = Sim.changeset(%Sim{}, params)
    [changeset: changeset]
  end

  describe "sims" do

    @tag name: "Valid name"
    test "valid changeset", %{changeset: changeset} do
      assert changeset.valid?
    end

    @tag name: ""
    test "name is required", %{changeset: changeset} do
      refute changeset.valid?
      assert changeset.errors == [name: {"can't be blank", [validation: :required]}]
    end
  end
end
