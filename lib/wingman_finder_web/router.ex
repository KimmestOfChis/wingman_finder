defmodule WingmanFinderWeb.Router do
  use WingmanFinderWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", WingmanFinderWeb do
    pipe_through :api

    resources("/sims", SimController, only: [:create, :index, :show, :update])
    resources("/modules", ModuleController, only: [:create, :index, :show, :update])
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: WingmanFinderWeb.Telemetry
    end
  end
end
