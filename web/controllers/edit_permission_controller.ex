defmodule PlanIt.EditPermissionController do
  alias PlanIt.Repo
  alias PlanIt.User
  alias PlanIt.Trip
  alias PlanIt.EditPermission
  import Ecto.Query

  use PlanIt.Web, :controller

  # GET - see if a certain user has permission to edit a trip
  def index(conn, %{"user_id" => user_id, "trip_id" => trip_id} = params) do
    if user_id == nil or trip_id == nil do
      json put_status(conn, 400), "no trip_id or user_id provided"
    end

    permission_users = (from p in PlanIt.EditPermission,
      where: p.trip_id == ^trip_id and p.user_id == ^user_id,
      select: p)
      |> Repo.one

    if permission_users == nil do
      json conn, false
    end

    json conn, true

  end

  # GET - get all users with permission to edit a trip
  def index(conn, %{"trip_id" => trip_id } = params) do
    if trip_id == nil do
      json put_status(conn, 400), "no trip_id provided"
    end

    permission_users = (from p in PlanIt.EditPermission,
      where: p.trip_id == ^trip_id,
      select: p.user_id)
      |> Repo.all

    json conn, permission_users
  end

  # POST - give edit permissions to a list of users
  def create(conn, %{"_json" => users} = params) do

      changesets = Enum.map(users, fn(u) ->
      	EditPermission.changeset(%EditPermission{}, u)
      end)

      Enum.each(changesets, fn(u) ->
        case Repo.insert(u) do
          {:ok, changeset} -> nil
          {:error, changeset} -> json put_status(conn, 400), "error: #{inspect changeset.errors}"
        end
      end)

      json conn, "ok"
  end


  # DELETE - remove edit permission for a given user and trip
  def remove(conn, %{"user_id" => user_id, "trip_id" => trip_id}) do

    permission_user = (from p in EditPermission,
      where: p.user_id == ^user_id and p.trip_id == ^trip_id,
      select: p
    ) |> Repo.one

    case Repo.delete permission_user do
      {:ok, struct} -> json conn, "ok"
      {:error, changeset} -> json put_status(conn, 400), "failed to delete"
    end
  end

end

