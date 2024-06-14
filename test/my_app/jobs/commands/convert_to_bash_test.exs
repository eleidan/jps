defmodule MyApp.Jobs.Commands.ConvertToBashTest do
  use ExUnit.Case, async: true

  @module MyApp.Jobs.Commands.ConvertToBash

  @data %{
    tasks: [
      %{command: "touch /tmp/file1", name: "task-1"},
      %{command: "echo 'Hello World!' > /tmp/file1", name: "task-3"},
      %{command: "cat /tmp/file1", name: "task-2"},
      %{command: "rm /tmp/file1", name: "task-4"}
    ]
  }

  setup context do
    function = context[:function]
    result = fn attrs -> apply(@module, function, attrs) end
    {:ok, result: result}
  end

  describe "run/1," do
    @describetag function: :run

    @describetag params: [@data]
    @describetag bash_script_content: File.read!("test/data/jobs_convert_to_bash.txt")
    test "with valid input", %{result: result, params: params, bash_script_content: content} do
      assert {:ok, text} = result.(params)
      assert text == content
    end
  end
end
