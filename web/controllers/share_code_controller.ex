defmodule PlanIt.ShareCodeController do
  alias PlanIt.Repo
  alias PlanIt.ShareCode
  alias PlanIt.EditPermission

  import Ecto.Query
  import Ecto.Changeset

  use PlanIt.Web, :controller


  #Two methods
  #One to create the code
  #One to verify the code

  #GET verify the code
  def index(conn, %{"verify" => code, "user_id" => user_id, "trip_id" => trip_id} = params) do
    sharecode = (from s in ShareCode,
        where: s.code == ^code and s.used == false,
        select: s) |> Repo.one

    unless sharecode do
      json conn, "no"
    end

    Repo.update(ShareCode.changeset(sharecode, %{used: true}))
    Repo.insert(EditPermission.changeset(%EditPermission{}, %{user_id: user_id, trip_id: trip_id}))

    json conn, "yes"
  end

  #GET create code
  def index(conn, %{"trip_id" => trip_id}) do
    uuid = Ecto.UUID.generate()
    Repo.insert(ShareCode.changeset(%ShareCode{}, %{code: uuid, trip_id: trip_id}))
    json conn, uuid
  end

  #GET catchall
  def index(conn, _params) do
    json put_status(conn, 400), "bad request"
  end

end
