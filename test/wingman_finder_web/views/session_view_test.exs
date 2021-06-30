defmodule WingmanFinderWeb.SessionViewTest do
  use WingmanFinderWeb.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  @access_token "token"

  test "renders show.json" do
    assert %{access_token: @access_token} =
             render(WingmanFinderWeb.SessionView, "show.json", access_token: @access_token)
  end

  test "renders missing_create_param.json" do
    assert %{
             error:
               "missing required parameter. required params are username, password, client_id, and client_secret"
           } = render(WingmanFinderWeb.SessionView, "missing_create_param.json", [])
  end
end
