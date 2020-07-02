defmodule MyAppWeb.Router do
  use MyAppWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/v2", MyAppWeb do
    pipe_through :api
    get "/user", UserController, :index
    resources "/user/delete", UserController, only: [:delete]
    post "/user/signup", UserController, :create
    put "/user/update/:id", UserController, :update

  end

  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: MyAppWeb.Telemetry
    end
  end
end
