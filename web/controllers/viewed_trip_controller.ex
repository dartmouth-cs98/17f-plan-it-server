defmodule PlanIt.ViewedTripController do
  alias PlanIt.Repo
  alias PlanIt.User
  alias PlanIt.Trip
  alias PlanIt.ViewedTrip
  import Ecto.Query

  use PlanIt.Web, :controller

  # GET - get all trips viewed by a user
  def index(conn, %{"user_id" => user_id } = params) do
    if user_id == nil do
      json put_status(conn, 400), "no user_id provided"
    end

    viewed_trips = (from t in PlanIt.ViewedTrip,
      where: t.user_id == ^user_id,
      select: t,
      order_by: [desc: :last_visited])
      |> Repo.all

    json conn, viewed_trips
  end

  # GET - bad params
  def index(conn, _params) do
    error = "no resource available"
    json put_status(conn, 400), error
  end

  # POST - insert a new viewed trip
  def create(conn, params) do
    {message, changeset} = ViewedTrip.insert_trip(params)

    if message == :error  do
      error = "error: #{inspect changeset.errors}"
      json put_status(conn, 400), error
    end

    json conn, changeset.id
  end

  # PUT - update an existing viewed trip
  def change(conn, %{"user_id" => user_id, "trip_id" => trip_id} = params) do

    IO.inspect(params)

    viewed_trip = (from t in ViewedTrip,
      where: t.user_id == ^user_id and t.trip_id == ^trip_id,
      select: t
    ) |> Repo.one

    changeset = ViewedTrip.changeset(viewed_trip, params)

    {message, changeset} = Repo.update(changeset)

    if message == :error do
      error = "error: #{inspect changeset.errors}"
      json put_status(conn, 400), error
    end

    json conn, "ok"
  end

end