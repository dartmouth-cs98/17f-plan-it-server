defmodule PlanIt.FavoritedTrip do
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:id, :id, autogenerate: true}
  schema "favorited_trip" do
    belongs_to :user, PlanIt.User
    belongs_to :trip, PlanIt.Trip

    field :last_visited, :utc_datetime

    timestamps()
  end

  def changeset(favorited_trip, params) do
    favorited_trip |> cast(params, [:user_id, :trip_id, :last_visited])
  end
end
