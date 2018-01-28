defmodule PlanIt.EditPermission do
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:id, :id, autogenerate: true}
  schema "edit_permission" do
    belongs_to :user, PlanIt.User
    belongs_to :trip, PlanIt.Trip

    timestamps()
  end

  def changeset(edit_permission, params) do
    IO.inspect("WHATEVER")
    edit_permission 
      |> cast(params, [:user_id, :trip_id])
      |> unique_constraint(:uniqueindex, name: :edit_permission_index_name)

  end
end