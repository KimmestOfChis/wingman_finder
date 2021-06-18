defmodule WingmanFinder.Schema do
  @moduledoc """
  base for all schemas within the application
  """

  defmacro __using__(_) do
    quote do
      use Ecto.Schema
      @timestamps_opts [type: :utc_datetime]

      import Ecto.Changeset
    end
  end
end
