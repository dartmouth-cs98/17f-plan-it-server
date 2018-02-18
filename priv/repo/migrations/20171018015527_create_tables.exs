defmodule PlanIt.Repo.Migrations.CreateTables do
  use Ecto.Migration

  def change do

    create table(:user) do
      add :fname, :string
      add :lname, :string
      add :email, :string
      add :username, :string
      add :birthday, :date

      timestamps()
    end

    create unique_index(:user, [:email])
    create unique_index(:user, [:username])

    create table(:trip) do
      add :name, :string
      add :publish, :boolean
      add :photo_url, :text
      add :upvotes, :integer, default: 0
      add :downvotes, :integer, default: 0
      add :start_time, :utc_datetime
      add :end_time, :utc_datetime

      add :user_id, references(:user)

      timestamps()
    end

    create table(:card) do

      add :name, :string
      add :address, :string
      add :city, :string
      add :state, :string
      add :country, :string
      add :zip_code, :integer
      add :lat, :float
      add :long, :float
      add :start_time, :utc_datetime
      add :end_time, :utc_datetime
      add :day_number, :integer

      add :type, :string
      add :description, :string
      add :photo_url, :string
      add :url, :string
      add :price, :string
      add :rating, :string
      add :phone, :string
      add :source, :string

      add :place_id, :string
      add :travel_type, :string
      add :travel_duration, :integer

      add :queue, :boolean

      add :trip_id, references(:trip, on_delete: :delete_all)

      timestamps()
    end

    create table(:favorited_trip) do
      add :last_visited, :utc_datetime
      add :trip_name, :string
      add :photo_url, :text
      add :user_id, references(:user)
      add :trip_id, references(:trip, on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:favorited_trip, [:user_id, :trip_id], name: :unique_favorited_trip)

    create table(:viewed_trip) do
      add :last_visited, :utc_datetime
      add :trip_name, :string
      add :photo_url, :text
      add :user_id, references(:user)
      add :trip_id, references(:trip, on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:viewed_trip, [:user_id, :trip_id], name: :unique_viewed_trip)

    create table(:edit_permission) do
      add :user_id, references(:user)
      add :trip_id, references(:trip, on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:edit_permission, [:user_id, :trip_id], name: :unique_edit_permission)

    create table(:token) do
      add :service, :string
      add :token_type, :string
      add :access_token, :string
      add :expires_at, :integer

      timestamps()

    end

  end
end
