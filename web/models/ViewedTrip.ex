defmodule PlanIt.ViewedTrip do
  use Ecto.Schema

  alias PlanIt.ViewedTrip
  alias PlanIt.Repo
  alias PlanIt.Trip

  import Ecto.Changeset

  @primary_key {:id, :id, autogenerate: true}
  schema "viewed_trip" do
    belongs_to :user, PlanIt.User
    belongs_to :trip, PlanIt.Trip

    field :last_visited, :utc_datetime
    field :trip_name, :string
    field :photo_url, :string

    timestamps()
  end

  def insert_trip(params) do

    %{"user_id" => user_id, "trip_id" => trip_id} = params
    trip = Repo.get(Trip, trip_id)
    trip_name = trip.name
    photo_url = trip.photo_url

    new_params = %{
      "trip_id": trip_id,
      "user_id": user_id,
      "trip_name": trip_name,
      "photo_url": photo_url,
      "last_visited": DateTime.utc_now
    }
    {message, changeset}  = Repo.insert(PlanIt.ViewedTrip.changeset(%PlanIt.ViewedTrip{}, new_params))

  end

  def changeset(viewed_trip, params) do
    viewed_trip 
      |> cast(params, [:user_id, :trip_id, :last_visited, :trip_name, :photo_url])
      |> unique_constraint(:uniqueindex, name: :unique_viewed_trip)
  end
end