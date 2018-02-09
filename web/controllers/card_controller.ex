defmodule PlanIt.CardController do
  alias PlanIt.Repo
  alias PlanIt.Card
  alias PlanIt.CardUtil

  import Ecto.Query
  import Ecto.Changeset

  use PlanIt.Web, :controller

  # GET - get all cards on a specific day of a specific trip
  def index(conn, %{"trip_id" => trip_id, "day" => day_num}) do
    if trip_id == nil or day_num == nil do
      json put_status(conn, 400), "bad parameters"
    end

    cards = (from c in Card,
          where: c.trip_id == ^trip_id and c.day_number == ^day_num,
          select: c,
          order_by: [asc: :start_time]
    ) |> Repo.all

    json conn, cards
  end

  # GET - get all cards on a specific trip
  def index(conn,%{"trip_id" => trip_id} = params) do
    if trip_id == nil do
      json put_status(conn, 400), "bad parameters"
    end

    cards = (from c in Card,
          where: c.trip_id == ^trip_id,
          select: c,
          order_by: [asc: :start_time]
    ) |> Repo.all

    json conn, cards
  end

  # GET - bad params
  def index(conn, _params) do
    error = "no resource available"
    json put_status(conn, 400), error
  end

  #POST update/create with a list of cards
  ## the new card will have an ID of 0
  def create(conn, %{"trip_id" => trip_id, "_json" => cards}) do
    {message, package} = CardUtil.create_update_helper(trip_id, cards)
    if message == :error do
      json put_status(conn, 400), package
    else
      json conn, package
    end
  end


  # POST - insert new cards
  def create(conn, %{"_json" => cards } = params) do
    return_items = Enum.map(cards, fn(c) ->
      {status, changeset} = Card.changeset(%Card{}, c) |> Repo.insert()
    end)

    changesets = Enum.map(return_items, fn(c) ->
      case c do
        {:ok, changeset} -> changeset
        _ ->
      end
    end)
    |> Enum.filter(fn(i) -> i end)

    messages = Enum.map(return_items, fn(c) ->
      case c do
        {:error, message} -> message
         _ -> nil
      end
    end)
    |> Enum.filter(fn(i) -> i end)

    json conn, changesets
  end


  # PUT - update an existing card
  def update(conn, %{"id" => card_id} = params) do
    card = Repo.get(Card, card_id)
    changeset = Card.changeset(card, params)

    {message, changeset} = Repo.update(changeset)

    if message == :error do
      error = "error: #{inspect changeset.errors}"
      json put_status(conn, 400), error
    end

    json conn, "ok"
  end

  # DELETE - delete a card
  def delete(conn, %{"id" => card_id} = params) do
    card = Repo.get!(Card, card_id)
    case Repo.delete card do
      {:ok, struct} -> json conn, "ok"
      {:error, changeset} -> json put_status(conn, 400), "failed to delete"
    end
  end
end
