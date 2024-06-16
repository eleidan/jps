defmodule MyApp.Jobs.Commands.ResolveJobTest do
  use ExUnit.Case, async: true

  @module MyApp.Jobs.Commands.ResolveJob

  @data File.read!("test/data/jobs_resolve_valid.json")
        |> Jason.decode!(keys: :atoms)
  @job MyApp.Jobs.Job.from_map(@data) |> elem(1) |> MyApp.Jobs.Job.as_map()
  @tasks @job[:tasks]

  setup context do
    function = context[:function]
    result = fn attrs -> apply(@module, function, attrs) end
    {:ok, result: result}
  end

  describe "run/1," do
    @describetag function: :run

    setup context do
      data = context[:json] |> Jason.decode!(keys: :atoms)

      job =
        MyApp.Jobs.Job.from_map(data) |> elem(1) |> MyApp.Jobs.Job.as_map()

      {:ok, params: [job]}
    end

    @describetag json: File.read!("test/data/jobs_resolve_valid.json")
    test "with valid input", %{result: result, params: params} do
      assert {:ok,
              [
                %{command: "touch /tmp/file1", name: "task-1", requires: nil},
                %{
                  command: "echo 'Hello World!' > /tmp/file1",
                  name: "task-3",
                  requires: ["task-1"]
                },
                %{command: "cat /tmp/file1", name: "task-2", requires: ["task-3"]},
                %{command: "rm /tmp/file1", name: "task-4", requires: ["task-2", "task-3"]}
              ]} == result.(params)
    end
  end

  describe "resolvable?/2," do
    @describetag function: :resolvable?
    @task Enum.at(@tasks, 0)

    @describetag params: [@task, []]
    test "with task without dependencies, and empty list", %{result: result, params: params} do
      assert result.(params) == true
    end

    @describetag params: [Map.merge(@task, %{requires: ["task-X"]}), ["task-X"]]
    test "with task with dependencies, and with dependendant task in the list", %{
      result: result,
      params: params
    } do
      assert result.(params) == true
    end

    @describetag params: [Map.merge(@task, %{requires: ["task-X"]}), ["task-Y", "task-X"]]
    test "with task with dependencies, and with dependendant task in the list of many", %{
      result: result,
      params: params
    } do
      assert result.(params) == true
    end

    @describetag params: [Map.merge(@task, %{requires: ["task-Z"]}), ["task-Y", "task-X"]]
    test "with task with dependencies, and without dependendant task in the list of many", %{
      result: result,
      params: params
    } do
      assert result.(params) == false
    end

    @describetag params: [Map.merge(@task, %{requires: ["missing"]}), []]
    test "with task with dependencies, and empty list", %{result: result, params: params} do
      assert result.(params) == false
    end
  end

  describe "resolve_tasks/3" do
    @describetag function: :resolve_tasks
    @describetag params: [@tasks, [], []]
    test "with valid input", %{result: result, params: params} do
      assert [
               %{command: "touch /tmp/file1", name: "task-1", requires: nil},
               %{
                 command: "echo 'Hello World!' > /tmp/file1",
                 name: "task-3",
                 requires: ["task-1"]
               },
               %{command: "cat /tmp/file1", name: "task-2", requires: ["task-3"]},
               %{command: "rm /tmp/file1", name: "task-4", requires: ["task-2", "task-3"]}
             ] == result.(params)
    end
  end
end
