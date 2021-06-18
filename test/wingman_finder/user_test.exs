defmodule WingmanFinder.UserTest do
  use WingmanFinder.DataCase

  import WingmanFinder.Factory

  alias WingmanFinder.User

  setup do
    params = params_for(:user)

    [params: params]
  end

  describe "changeset/2" do
    test "valid changeset", %{params: params} do
      changeset = User.changeset(%User{}, params)
      assert changeset.valid?
    end

    @required_fields [
      :username,
      :email,
      :password
    ]
    for required_field <- @required_fields do
      @tag field_name: required_field
      test "#{required_field} is required", %{params: params, field_name: field_name} do
        {_value, invalid_params} = Map.pop(params, field_name)

        changeset = User.changeset(%User{}, invalid_params)

        refute changeset.valid?
        assert changeset.errors[field_name] == {"can't be blank", [validation: :required]}
      end
    end
  end
end
