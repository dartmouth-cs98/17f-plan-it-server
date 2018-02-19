defmodule PlanIt.Card do
  use Ecto.Schema

  import Ecto.Changeset
  @primary_key {:id, :id, autogenerate: true}
  schema "card" do
    belongs_to :trip, PlanIt.Trip

    field :name, :string
    field :address, :string
    field :city, :string
    field :state, :string
    field :country, :string
    field :zip_code, :integer
    field :lat, :float
    field :long, :float
    field :start_time, :utc_datetime
    field :end_time, :utc_datetime
    field :day_number, :integer

    field :type, :string
    field :description, :string
    field :photo_url, :string
    field :url, :string
    field :price, :string
    field :rating, :string
    field :phone, :string
    field :source, :string

    field :queue, :boolean

    field :place_id, :string
    field :travel_type, :string
    field :travel_duration, :integer

    timestamps()
  end

  def changeset(card, params) do

    card
    |> cast(params, [:name, :address, :city, :state, :country, :zip_code, :lat, :long, :start_time, :end_time, :day_number,
      :type, :description, :photo_url, :url, :price, :rating, :phone, :source, :place_id, :travel_type, :travel_duration])
    |> cast(params, [:trip_id])
    |> validate_required([:name])
  end

  def changesetQueue(card, params) do
    card
    |> cast(params, [:name, :address, :city, :state, :country, :zip_code, :lat, :long, :start_time, :end_time, :day_number,
      :type, :description, :photo_url, :url, :price, :rating, :phone, :source, :place_id, :travel_type, :travel_duration])
    |> cast(params, [:trip_id])
    |> cast(%{"queue" => true}, [:queue])
    |> validate_required([:name])
  end

  def changesetItinerary(card, params) do
    card
    |> cast(params, [:name, :address, :city, :state, :country, :zip_code, :lat, :long, :start_time, :end_time, :day_number,
      :type, :description, :photo_url, :url, :price, :rating, :phone, :source, :place_id, :travel_type, :travel_duration])
    |> cast(params, [:trip_id])
    |> cast(%{"queue" => false}, [:queue])
    |> validate_required([:name])
  end

end
