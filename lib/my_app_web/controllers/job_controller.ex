defmodule MyAppWeb.JobController do
  use MyAppWeb, :controller

  alias MyApp.Jobs

  action_fallback MyAppWeb.FallbackController

  def convert(conn, params) do
    with {:ok, tasks} <- Jobs.resolve(params),
         {:ok, result} <- Jobs.convert(%{tasks: tasks}) do
      conn
      |> put_status(:created)
      |> text(result)
    end
  end

  def resolve(conn, params) do
    with {:ok, tasks} <- Jobs.resolve(params) do
      conn
      |> put_status(:created)
      |> render(:resolve, %{tasks: tasks})
    end
  end
end
