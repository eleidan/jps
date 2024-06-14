defmodule MyApp.Jobs do
  @moduledoc """
  The Jobs context.
  """

  alias MyApp.Jobs.Job

  def resolve(data) do
    with {:ok, job} <- Job.changeset(%Job{}, data),
         %{} = data <- Job.as_map(job) do
      result = MyApp.Jobs.Commands.ResolveJob.run(data)
      result
    end
  end
end
