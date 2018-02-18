defmodule PlanIt.QueueCardController do
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
          where: c.trip_id == ^trip_id and c.day_number == ^day_num and c.queue == true,
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
          where: c.trip_id == ^trip_id and c.queue == true,
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

  #POST create a single card
  def create(conn, params) do
    {message, changeset} = Repo.insert(Card.changesetQueue(%Card{}, params))

    if message == :error do
      json put_status(conn, 400), changeset
    else
      json conn, changeset
    end
  end

  # PUT - update an existing card
  def update(conn, %{"id" => card_id} = params) do
    card = Repo.get(Card, card_id)
    changeset = Card.changesetQueue(card, params)

    {message, changeset} = Repo.update(changeset)

    if message == :error do
      error = "error: #{inspect changeset.errors}"
      json put_status(conn, 400), error
    end

    json conn, changeset
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
