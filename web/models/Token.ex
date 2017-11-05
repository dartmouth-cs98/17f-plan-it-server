defmodule PlanIt.Token do
  use PlanIt.Web, :model

  schema "token" do
    field :service, :string
    field :token_type, :string
    field :access_token, :string
    field :expires_at, :integer

    timestamps()
  end
end
