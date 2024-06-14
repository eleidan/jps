defmodule MyAppWeb.JobControllerTest do
  use MyAppWeb.ConnCase

  describe "resolve" do
    setup context do
      conn = context[:conn]
      data = context[:json] |> Jason.decode!()

      {:ok, data: data, conn: put_req_header(conn, "accept", "application/json")}
    end

    @describetag json: File.read!("test/data/jobs_resolve_valid.json")
    test "with valid data", %{conn: conn, data: data} do
      conn = post(conn, ~p"/api/jobs/resolve", data)

      assert [
              %{"command" => "touch /tmp/file1", "name" => "task-1"},
              %{"command" => "echo 'Hello World!' > /tmp/file1", "name" => "task-3"},
              %{"command" => "cat /tmp/file1", "name" => "task-2"},
              %{"command" => "rm /tmp/file1", "name" => "task-4"}
            ] = json_response(conn, 201)["tasks"]
    end

    @describetag json: File.read!("test/data/jobs_resolve_invalid_without_task_command.json")
    test "without task command, returns error message", %{conn: conn, data: data} do
      conn = post(conn, ~p"/api/jobs/resolve", data)

      assert %{"tasks" => [%{"command" => ["can't be blank"]}, %{}, %{}, %{}]} =
               json_response(conn, 422)["errors"]
    end

  end
end
