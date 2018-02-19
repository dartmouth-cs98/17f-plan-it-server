defmodule PlanIt.ShareCode do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :id, autogenerate: true}
  schema "share_code" do
    belongs_to :user, PlanIt.User

    field :code, :string
    field :used, :boolean, default: false
    field :expire_at, :integer

    timestamps()
  end

  def changeset(sharecode, params) do
    sharecode
    |> cast(params, [:code, :used, :user_id])
    |> validate_required([:code])
    #    |> validate_required([:code, :user_id])
  end
end
