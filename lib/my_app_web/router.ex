defmodule MyAppWeb.Router do
  use MyAppWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", MyAppWeb do
    pipe_through :api
    post "/jobs/resolve", JobController, :resolve
    post "/jobs/convert", JobController, :convert
  end
end
