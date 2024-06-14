defmodule MyAppWeb.JobJSON do
  @doc """
  Renders a job with list of resolved tasks.
  """
  def resolve(conn) when is_map(conn) do
    %{tasks: for(task <- conn[:tasks], do: data(task))}
  end

  defp data(%{} = task) do
    %{
      name: task[:name],
      command: task[:command]
    }
  end
end
