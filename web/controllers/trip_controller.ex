defmodule PlanIt.TripController do
  alias PlanIt.Repo
  alias PlanIt.Card
  alias PlanIt.Trip
  alias PlanIt.EditPermission
  import Ecto.Query

  use PlanIt.Web, :controller
  
  # GET - get all trips created by a user
  def index(conn, %{"user_id" => user_id } = params) do
    if user_id == nil do
      json put_status(conn, 400), "no user_id provided"
    end

    trips = (from t in PlanIt.Trip,
      where: t.user_id == ^user_id,
      select: t) |> Repo.all

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

  # POST - insert a copy of an existing trip
  def create(conn, %{"original_id" => original_id } = params) do
    card_query = from c in Card,
      order_by: c.start_time

    trip = (from t in PlanIt.Trip,
      where: t.id == ^original_id,
      select: t,
      preload: [card: ^card_query]) |> Repo.one


      if Map.get(params, "name") == nil do
        params = Map.put(params, "name", trip.name)
      end

      {message, changeset} = Trip.insert_trip(params)
      if message == :error  do
        error = "error: #{inspect changeset.errors}"
        json put_status(conn, 400), error
      end


      new_cards = Enum.map(trip.card, fn(c) ->
        c
        |> Map.delete(:__meta__)
        |> Map.delete(:__struct__)
        |> Map.delete(:updated_at)
        |> Map.delete(:created_at)
        |> Map.delete(:id)
        |> Map.delete(:trip)
        |> Map.put(:trip_id, changeset.id)
      end)

      repo_messages = Enum.each(new_cards, fn(c) -> Repo.insert(Card.changeset(%Card{}, c)) end)

      changeset_errors = Enum.map(repo_messages, fn(m) ->
        case m do
          {:ok, changeset} -> changeset
          {:error, message} -> json put_status(conn, 400), "error: #{inspect message}"
          _ -> m
          end
      end)


      json conn, changeset.id
  end

  # POST - insert a new trip
  def create(conn, params) do
    {message, changeset} = Trip.insert_trip(params)

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

  def upvote(conn, %{"trip_id" => trip_id}) do
    trip = Repo.get(Trip, trip_id)
    foo = %{upvotes: trip.upvotes + 1}
    changeset = Trip.changeset(trip, foo)

    {message, changeset} = Repo.update(changeset)

    if message == :ok do
      json conn, "ok"
    else
      error = "error: #{inspect changeset.errors}"
      json put_status(conn, 400), error
    end
  end

  def downvote(conn, %{"trip_id" => trip_id}) do
    trip = Repo.get(Trip, trip_id)
    foo = %{downvotes: trip.downvotes + 1}
    changeset = Trip.changeset(trip, foo)

    {message, changeset} = Repo.update(changeset)

    if message == :ok do
      json conn, "ok"
    else
      error = "error: #{inspect changeset.errors}"
      json put_status(conn, 400), error
    end
  end
end
