defmodule PlanIt.ShareCodeController do
  alias PlanIt.Repo
  alias PlanIt.ShareCode

  import Ecto.Query
  import Ecto.Changeset

  use PlanIt.Web, :controller


  #Two methods
  #One to create the code
  #One to verify the code

  #GET verify the code
  def index(conn, %{"verify" => code} = params) do
    sharecode = (from s in ShareCode,
        where: s.code == ^code and s.used == false,
        select: s) |> Repo.one

    unless sharecode do
      json conn, "no"
    end

      Repo.update(ShareCode.changeset(sharecode, %{used: true}))
      json conn, "yes"
  end

  #GET create code
  def index(conn, params) do
    uuid = Ecto.UUID.generate()
    Repo.insert(ShareCode.changeset(%ShareCode{}, %{code: uuid}))
    json conn, uuid
  end

end
