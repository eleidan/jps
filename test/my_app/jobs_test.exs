defmodule MyApp.JobsTest do
  use ExUnit.Case, async: true

  @module MyApp.Jobs

  setup context do
    function = context[:function]
    result = fn attrs -> apply(@module, function, attrs) end
    {:ok, result: result}
  end

  describe "resolve/1" do
    @describetag function: :resolve

    setup context do
      data = context[:json] |> Jason.decode!(keys: :atoms)
      {:ok, params: [data]}
    end

    @describetag json: File.read!("test/data/jobs_resolve_valid.json")
    test "with valid input", %{result: result, params: params} do
      assert {
               :ok,
               [
                 %{command: "touch /tmp/file1", name: "task-1", requires: nil},
                 %{
                   command: "echo 'Hello World!' > /tmp/file1",
                   name: "task-3",
                   requires: ["task-1"]
                 },
                 %{command: "cat /tmp/file1", name: "task-2", requires: ["task-3"]},
                 %{command: "rm /tmp/file1", name: "task-4", requires: ["task-2", "task-3"]}
               ]
             } == result.(params)
    end

    @describetag json: File.read!("test/data/jobs_resolve_invalid_with_task_duplication.json")
    test "with task duplication", %{result: result, params: params} do
      result.(params)
    end

    @describetag json: File.read!("test/data/jobs_resolve_invalid_without_task_command.json")
    test "without task command, returns {:error, %Ecto.Changeset{}}", %{
      result: result,
      params: params
    } do
      assert {:error, %Ecto.Changeset{}} = result.(params)
    end
  end
end
