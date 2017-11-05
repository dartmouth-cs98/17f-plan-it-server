defmodule PlanIt.YelpController do

  use PlanIt.Web, :controller
  use HTTPoison.Base
  alias OAuth2
  alias PlanIt.Card
  alias PlanIt.YelpHelper
  alias PlanIt.Repo
  alias PlanIt.Token

  @api_url "https://api.yelp.com/v3/"

  def index(conn, _params) do
    json conn, "ok"
  end



  def get_token() do
    # id = Application.get_env(:yelp, :id)
    # secret = Application.get_env(:yelp, :secret)

    db_token = Repo.one(from t in Token,
      where: t.service == "yelp",
      select: t
    )

    if db_token  == nil do
      id = "CYQN92eKQPcAzMpfGvDknA"
      secret = "sJ3mr4cd3TGZmJ9x1icWJdxpgPqELci5pRDDeYHJME9S4SBiKy16XtB2hJo7iXvu"

      client = YelpHelper.create_client(id, secret)

      {message, token} = YelpHelper.get_token(client)
      Repo.insert(%Token{
        service: "yelp",
        access_token: token.access_token,
        token_type: token.token_type,
        expires_at: token.expires_at
      })

      token
    else
      db_token
    end





  end
  def topplaces(conn, %{"latitude" => lat, "longitude" => long} = params) do

    token = get_token()

    request_url = "https://api.yelp.com/v3/businesses/search?latitude=#{lat}&longitude=#{long}"
    #request_url = "https://api.yelp.com/v3/businesses/search?location=03755"
    headers = ["Authorization": "#{token.token_type} #{token.access_token}"]

    response = HTTPoison.get!(request_url, headers)

    body = Poison.decode!(response.body)

    businesses = Map.get(body, "businesses")

    json conn, businesses
	end


end
