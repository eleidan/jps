defmodule MyApp.Jobs.Commands.ConvertToBash do
  @compile if Mix.env() == :test, do: :export_all

  def run(%{} = params) do
    tasks = params[:tasks]
    result = covert_to_bash(tasks)
    {:ok, "#!/usr/bin/env bash\n" <> result <> "\n"}
  end

  defp covert_to_bash(tasks) do
    tasks
    |> Enum.map(fn task -> task[:command] end)
    |> Enum.join("\n")
  end
end
