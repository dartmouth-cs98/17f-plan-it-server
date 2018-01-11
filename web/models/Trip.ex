defmodule PlanIt.Trip do
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:id, :id, autogenerate: true}
  schema "trip" do
    belongs_to :user, PlanIt.User

    field :name, :string
    field :publish, :boolean
    field :upvotes, :integer, default: 0
    field :downvotes, :integer, default: 0
    field :photo_url, :string
    field :start_time, :utc_datetime
    field :end_time, :utc_datetime

    has_many :card, PlanIt.Card
    has_many :favorited_trip, PlanIt.Trip

    timestamps()
  end

  def changeset(trip, params) do
    trip |> cast(params, [:name, :publish, :upvotes, :downvotes, :photo_url, :start_time, :end_time, :user_id])
  end
end
