defmodule WingmanFinderWeb.ErrorHelpersTest do
  use WingmanFinder.DataCase
  import WingmanFinder.Factory

  alias WingmanFinder.Module
  alias WingmanFinderWeb.ErrorHelpers

  describe "handle_errors" do
    test "it converts changeset errors into readable format" do
      params = params_for(:module, name: "", sim_id: nil)

      changeset = Module.changeset(%Module{}, params)

      assert ErrorHelpers.handle_errors(changeset) == [
               %{name: "can't be blank"},
               %{sim_id: "can't be blank"}
             ]
    end
  end
end
