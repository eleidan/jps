defmodule MyAppWeb.JobControllerTest do
  use MyAppWeb.ConnCase

  describe "resolve" do
    setup context do
      conn = context[:conn]
      conn = put_req_header(conn, "accept", "application/json")
      data = context[:json] |> Jason.decode!()
      result = fn attrs -> post(conn, ~p"/api/jobs/resolve", attrs) end

      {:ok, params: data, result: result, conn: conn}
    end

    @describetag json: File.read!("test/data/jobs_resolve_valid.json")
    test "with valid data", %{result: result, params: params} do
      conn = result.(params)

      assert [
               %{"command" => "touch /tmp/file1", "name" => "task-1"},
               %{"command" => "echo 'Hello World!' > /tmp/file1", "name" => "task-3"},
               %{"command" => "cat /tmp/file1", "name" => "task-2"},
               %{"command" => "rm /tmp/file1", "name" => "task-4"}
             ] = json_response(conn, 201)["tasks"]
    end

    @describetag json: File.read!("test/data/jobs_resolve_invalid_without_task_command.json")
    test "without task command, returns error message", %{result: result, params: params} do
      conn = result.(params)

      assert %{"tasks" => [%{"command" => ["can't be blank"]}, %{}, %{}, %{}]} =
               json_response(conn, 422)["errors"]
    end
  end

  describe "convert" do
    setup context do
      conn = context[:conn]
      conn = put_req_header(conn, "accept", "application/json")
      data = context[:json] |> Jason.decode!()
      result = fn attrs -> post(conn, ~p"/api/jobs/convert", attrs) end

      {:ok, params: data, result: result, conn: conn}
    end

    @describetag json: File.read!("test/data/jobs_resolve_valid.json")
    @describetag bash_script_content: File.read!("test/data/jobs_convert_to_bash.txt")
    test "with valid data", %{result: result, params: params, bash_script_content: content} do
      conn = result.(params)

      assert content == text_response(conn, 201)
    end
  end
end
