defmodule PlanIt.FavoritedTrip do
  use Ecto.Schema

  alias PlanIt.FavoritedTrip
  alias PlanIt.Repo
  alias PlanIt.Trip


  import Ecto.Changeset

  @primary_key {:id, :id, autogenerate: true}
  schema "favorited_trip" do
    belongs_to :user, PlanIt.User
    belongs_to :trip, PlanIt.Trip

    field :last_visited, :utc_datetime
    field :trip_name, :string
    field :photo_url, :string

    timestamps()
  end

  def insert_favorited_trip(params) do

    # Insert into favorited_trip table
    IO.inspect(params)
    trip = Repo.get(Trip, params.trip_id)
    trip_name = trip.name
    photo_url = trip.photo_url

    new_params = %{
      "trip_id": params.trip_id,
      "user_id": params.used_id,
      "trip_name": trip_name,
      "photo_url": photo_url
    }
    {message, changeset}  = Repo.insert(PlanIt.FavoritedTrip.changeset(%PlanIt.FavoritedTrip{}, new_params))

    # Call upvote_trip to automatically upvote upon favoriting
    message2 = PlanIt.FavoritedTrip.upvote_trip(changeset)
    case {message, message2} do
      {:ok, :ok} -> {:ok, changeset}
      {_, :ok} -> {message, changeset}
      {:ok, _} -> {message2, changeset}
      _ -> {message, changeset}
    end
  end

  def upvote_trip(changeset) do

    trip = Repo.get(Trip, changeset.trip_id)
    num_upvotes = trip.upvotes + 1

    params = %{
      "upvotes": num_upvotes
    }

    changeset = Trip.changeset(trip, params)

    Repo.update(changeset)
  end

  def changeset(favorited_trip, params) do
    favorited_trip 
      |> cast(params, [:user_id, :trip_id, :last_visited, :trip_name, :photo_url])
      |> unique_constraint(:uniqueindex, name: :unique_favorited_trip)
  end
end
