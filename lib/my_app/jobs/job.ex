defmodule MyApp.Jobs.Job do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    embeds_many :tasks, Task, primary_key: false do
      field :command, :string
      field :name, :string
      field :requires, {:array, :string}
    end
  end

  def from_map(%{} = params) do
    %__MODULE__{}
    |> changeset(params)
    |> validate_duplication()
    |> apply_action(:insert)
  end

  def changeset(job, params) do
    job
    |> cast(params, [])
    |> cast_embed(:tasks, with: &tasks_changeset/2, required: :tasks)
  end

  def tasks_changeset(schema, params) do
    schema
    |> cast(params, [:command, :name, :requires])
    |> validate_required([:command, :name])
  end

  # |> tap(fn x -> IO.inspect(x) end)
  def validate_duplication(changeset) do
    validate_change(changeset, :tasks, fn :tasks, list ->
      names = for(task <- list, do: task.changes.name)

      duplicated_task_names =
        names
        |> Enum.uniq()
        |> then(fn uniq_names -> names -- uniq_names end)
        |> Enum.uniq()

      if length(duplicated_task_names) == 0 do
        []
      else
        [
          tasks:
            "the following task names are not unique: #{Enum.join(duplicated_task_names, ", ")}"
        ]
      end
    end)
  end

  def as_map(%__MODULE__{} = params) do
    %{tasks: for(task <- params.tasks, do: Map.from_struct(task))}
  end
end
