defmodule WingmanFinderWeb.FallbackController do
  use WingmanFinderWeb, :controller

  alias WingmanFinderWeb.ErrorView

  def call(conn, {:error, msg}) when is_binary(msg) do
    conn
    |> put_status(422)
    |> put_view(ErrorView)
    |> render("error.json", error: msg)
  end

  def call(conn, {:error, reason}) when is_atom(reason) do
    conn
    |> put_status(422)
    |> put_view(ErrorView)
    |> render("error.json", error: Atom.to_string(reason))
  end

  def call(conn, {:error, %Ecto.Changeset{errors: errors}}) do
    errors = Enum.map(errors, fn {field, {error, _}} -> "#{field} #{error}" end)

    conn
    |> put_status(422)
    |> put_view(ErrorView)
    |> render("errors.json", errors: errors)
  end
end
