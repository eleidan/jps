defmodule MyApp.Jobs do
  @moduledoc """
  The Jobs context.
  """

  alias MyApp.Jobs.Job

  def convert(data) do
    result = MyApp.Jobs.Commands.ConvertToBash.run(data)
    result
  end

  def resolve(data) do
    with {:ok, job} <- Job.changeset(%Job{}, data),
         %{} = data <- Job.as_map(job) do
      result = MyApp.Jobs.Commands.ResolveJob.run(data)
      result
    end
  end
end
