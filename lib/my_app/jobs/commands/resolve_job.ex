defmodule MyApp.Jobs.Commands.ResolveJob do
  @moduledoc false

  @compile if Mix.env() == :test, do: :export_all

  def run(%{} = params) do
    tasks = params[:tasks]
    result = resolve_tasks(tasks, [], [])
    {:ok, result}
  end

  defp resolvable?(%{requires: nil}, _), do: true

  defp resolvable?(%{} = task, resolved_tasks) when is_list(resolved_tasks) do
    task[:requires]
    |> Enum.map(fn required_task -> Enum.member?(resolved_tasks, required_task) end)
    |> Enum.all?()
  end

  defp resolve_tasks(_todo, _resolved_tasks, result, :done) do
    result
    |> Enum.reverse()
  end

  defp resolve_tasks(tasks_to_resolve, resolved_tasks, result) when is_list(tasks_to_resolve) do
    r =
      Enum.reduce(
        tasks_to_resolve,
        %{todo: tasks_to_resolve, resolved_tasks: resolved_tasks, result: result, counter: 0},
        fn task, acc ->
          counter = acc[:counter]
          td = acc[:todo]
          rt = acc[:resolved_tasks]
          rr = acc[:result]

          if resolvable?(task, rt) do
            counter = counter + 1

            %{
              todo: td -- [task],
              resolved_tasks: [task[:name] | rt],
              result: [task | rr],
              counter: counter + 1
            }
          else
            %{
              todo: td,
              resolved_tasks: rt,
              result: rr,
              counter: counter
            }
          end
        end
      )

    if r[:counter] > 0 do
      resolve_tasks(r[:todo], r[:resolved_tasks], r[:result])
    else
      resolve_tasks(r[:todo], r[:resolved_tasks], r[:result], :done)
    end
  end
end
