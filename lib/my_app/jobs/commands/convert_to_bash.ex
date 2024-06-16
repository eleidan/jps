defmodule MyApp.Jobs.Commands.ConvertToBash do
  @moduledoc false

  @compile if Mix.env() == :test, do: :export_all

  def run(%{} = params) do
    tasks = params[:tasks]
    result = covert_to_bash(tasks)
    {:ok, "#!/usr/bin/env bash\n" <> result <> "\n"}
  end

  defp covert_to_bash(tasks) do
    tasks
    |> Enum.map_join("\n", fn task -> task[:command] end)
  end
end
