defmodule PlanIt.Card do
  use Ecto.Schema

  import Ecto.Changeset
  @primary_key {:id, :id, autogenerate: true}
  schema "card" do
    belongs_to :trip, PlanIt.Trip

    field :type, :string
    field :name, :string
    field :city, :string
    field :country, :string
    field :address, :string
    field :lat, :float
    field :long, :float
    field :start_time, :utc_datetime
    field :end_time, :utc_datetime
    field :day_number, :integer

    field :description, :string
    field :photo_url, :string
    field :url, :string
    field :place_id, :string

    field :travel_type, :string
    field :travel_duration, :integer

    field :locked, :boolean

    timestamps()
  end

  def changeset(card, params) do
    card
    |> cast(params, [:type, :name, :city, :country, :address, :lat, :long, :start_time, :end_time, :day_number, :description, :photo_url, :url, :place_id, :travel_type, :travel_duration])
    |> cast(params, [:trip_id])
    |> validate_required([:name])
  end

  def lockset(card, params) do
    card
    |> cast(params, [:locked])
  end

end
