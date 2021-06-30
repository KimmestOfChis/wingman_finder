defmodule WingmanFinderWeb.SessionView do
  use WingmanFinderWeb, :view

  def render("show.json", %{access_token: access_token}), do: %{access_token: access_token}

  def render("missing_create_param.json", _),
    do: %{
      error:
        "missing required parameter. required params are username, password, client_id, and client_secret"
    }
end
