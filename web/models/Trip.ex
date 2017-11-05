defmodule PlanIt.Trip do
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:id, :id, autogenerate: true}
  schema "trip" do
    belongs_to :user, PlanIt.User

    field :name, :string
    field :publish, :boolean
    field :photo_url, :string

    has_many :card, PlanIt.Card
    has_many :favorited_trip, PlanIt.Trip

    timestamps()
  end

  def changeset(trip, params) do
    trip |> cast(params, [:name, :user_id, :photo_url])
  end
end
