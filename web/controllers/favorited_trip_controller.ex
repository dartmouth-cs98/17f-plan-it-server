defmodule PlanIt.FavoritedTripController do
  alias PlanIt.Repo
  alias PlanIt.User
  alias PlanIt.Trip
  alias PlanIt.FavoritedTrip
  import Ecto.Query

  use PlanIt.Web, :controller

  # GET - get all trips favorited by a user
  def index(conn, %{"user_id" => user_id } = params) do
    if user_id == nil do
      json put_status(conn, 400), "no user_id provided"
    end

    favorited_trips = (from t in PlanIt.FavoritedTrip,
      where: t.user_id == ^user_id,
      select: t,
      order_by: [desc: :last_visited])
      |> Repo.all

    json conn, favorited_trips
  end

  # GET - bad params
  def index(conn, _params) do
    error = "no resource available"
    json put_status(conn, 400), error
  end

  # POST - insert a new favorited trip
  def create(conn, params) do

      {message, changeset} = FavoritedTrip.insert_favorited_trip(params)

      if message == :error  do
        error = "error: #{inspect changeset.errors}"
        json put_status(conn, 400), error
      end

      json conn, "ok"
  end

  # PUT - update an existing favorited trip
  def change(conn, %{"user_id" => user_id, "trip_id" => trip_id} = params) do
    favorited_trip = (from t in FavoritedTrip,
      where: t.user_id == ^user_id and t.trip_id == ^trip_id,
      select: t
    ) |> Repo.one

    changeset = FavoritedTrip.changeset(favorited_trip, params)

    {message, changeset} = Repo.update(changeset)

    if message == :error do
      error = "error: #{inspect changeset.errors}"
      json put_status(conn, 400), error
    end

    json conn, "ok"
  end

  # DELETE - delete a favorited trip by user id and trip id
  def remove(conn, %{"user_id" => user_id, "trip_id" => trip_id}) do

    favorited_trip = (from t in FavoritedTrip,
      where: t.user_id == ^user_id and t.trip_id == ^trip_id,
      select: t
    ) |> Repo.one

    case Repo.delete favorited_trip do
      {:ok, struct} -> json conn, "ok"
      {:error, changeset} -> json put_status(conn, 400), "failed to delete"
    end
  end

end
