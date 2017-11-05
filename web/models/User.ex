defmodule PlanIt.User do
  use PlanIt.Web, :model

  import Ecto.Changeset

  @primary_key {:id, :id, autogenerate: true}
  schema "user" do
    field :fname, :string
    field :lname, :string
    field :email, :string
    field :username, :string
    field :birthday, :date

    has_many :trip, PlanIt.Trip
    has_many :favorited_trip, PlanIt.Trip
    timestamps()
  end

  def changeset(user, params) do
    user
    |> cast(params, [:fname, :lname, :email, :username, :birthday])
    |> validate_required([:email])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
    |> unique_constraint(:username)
  end
end
