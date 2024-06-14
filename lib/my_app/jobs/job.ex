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

  def changeset(job, params) do
    job
    |> cast(params, [])
    |> cast_embed(:tasks, with: &tasks_changeset/2, required: :tasks)
    |> validate_duplication()
    |> apply_action(:insert)
  end

  def tasks_changeset(schema, params) do
    schema
    |> cast(params, [:command, :name, :requires])
    |> validate_required([:command, :name])
  end

  # TODO: Make sure there are no duplicate task names
  def validate_duplication(changeset) do
    changeset
  end

  def as_map(%__MODULE__{} = params) do
    %{tasks: for(task <- params.tasks, do: Map.from_struct(task))}
  end
end
