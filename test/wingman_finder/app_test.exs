defmodule WingmanFinder.AppTest do
  use WingmanFinder.DataCase

  import WingmanFinder.Factory

  alias WingmanFinder.App

  setup do
    params = params_for(:app)

    [params: params]
  end

  describe "changeset/2" do
    test "valid changeset", %{params: params} do
      changeset = App.changeset(%App{}, params)
      assert changeset.valid?
    end

    @required_fields [
      :api_key,
      :api_secret,
      :display_name
    ]
    for required_field <- @required_fields do
      @tag field_name: required_field
      test "#{required_field} is required", %{params: params, field_name: field_name} do
        {_value, invalid_params} = Map.pop(params, field_name)

        changeset = App.changeset(%App{}, invalid_params)

        refute changeset.valid?
        assert changeset.errors[field_name] == {"can't be blank", [validation: :required]}
      end
    end
  end
end
