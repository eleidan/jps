defmodule MyApp.Jobs.JobTest do
  use ExUnit.Case, async: true

  alias MyApp.Jobs.Job

  @module MyApp.Jobs.Job

  setup context do
    function = context[:function]
    result = fn attrs -> apply(@module, function, attrs) end
    {:ok, result: result}
  end

  describe "validate_duplication/1" do
    @describetag function: :validate_duplication

    setup context do
      data = context[:json]
      map = Jason.decode!(data, keys: :atoms)
      changeset = Job.changeset(%Job{}, map)
      {:ok, params: [changeset]}
    end

    @describetag json: File.read!("test/data/jobs_resolve_valid.json")
    test "with valid input", %{result: result, params: params} do
      r = result.(params)
      assert %Ecto.Changeset{} = r
      assert true == r.valid?
      assert [] = r.errors
    end

    @describetag json: File.read!("test/data/jobs_resolve_invalid_with_task_duplication.json")
    test "with task duplication", %{result: result, params: params} do
      r = result.(params)
      assert %Ecto.Changeset{} = r
      assert false == r.valid?
      assert [{:tasks, {"the following task names are not unique: task-1", []}}] = r.errors
    end
  end
end
