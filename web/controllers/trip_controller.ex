defmodule PlanIt.TripController do
  alias PlanIt.Repo
  alias PlanIt.Card
  alias PlanIt.Trip
  import Ecto.Query

  use PlanIt.Web, :controller

  # GET - get all trips created by a user
  def index(conn, %{"user_id" => user_id } = params) do
    if user_id == nil do
      json put_status(conn, 400), "no user_id provided"
    end

    trips = (from t in PlanIt.Trip,
      where: t.user_id == ^user_id,
      select: t)
      |> Repo.all

    json conn, trips
  end

  def index(conn, _params) do
    trips = (from t in PlanIt.Trip,
      where: t.publish == true,
      select: t) |> Repo.all
    json conn, trips
  end

  # GET - get a trip by id
  def show(conn, %{"id" => trip_id } = params) do
    card_query = from c in Card,
      order_by: c.start_time

    trips = (from t in PlanIt.Trip,
      where: t.id == ^trip_id,

      select: t,
      preload: [card: ^card_query])
      |> Repo.all

    json conn, trips
  end

  # POST - insert a new trip
  def create(conn, params) do
    IO.inspect(params)

    {message, changeset} = Trip.changeset(%Trip{}, params)
    |> Repo.insert

    if message == :error  do
      error = "error: #{inspect changeset.errors}"
      json put_status(conn, 400), error
    end

    json conn, changeset.id
  end

  # PUT - update an existing trip
  def update(conn, %{"id" => trip_id} = params) do
    trip = Repo.get(Trip, trip_id)
    changeset = Trip.changeset(trip, params)

    {message, changeset} = Repo.update(changeset)

    if message == :ok do
      json conn, "ok"
    else
      error = "error: #{inspect changeset.errors}"
      json put_status(conn, 400), error
    end
  end

  # DELETE - delete an existing trip
  def delete(conn, %{"id" => trip_id}) do
    trip = Repo.get(Trip, trip_id)
    case Repo.delete trip do
      {:ok, struct} -> json conn, "ok"
      {:error, message} -> json put_status(conn, 400), "failed to delete"
    end
  end
end
