defmodule PlanIt.FoursquareController do

  use PlanIt.Web, :controller
  use HTTPoison.Base
  alias OAuth2
  alias PlanIt.Card
  alias PlanIt.FoursquareHelper
  alias PlanIt.Repo
  alias PlanIt.Token

  @api_url "https://api.foursquare.com/v2/"

  def index(conn, _params) do
    json conn, "ok"
  end

  def get_token() do
    # id = Application.get_env(:foursquare, :id)
    # secret = Application.get_env(:foursquare, :secret)

    db_token = Repo.one(from t in Token,
      where: t.service == "foursquare",
      select: t
    )

    if db_token  == nil do
      id = "TBYPUBXPXKEI1LF3SFWUWLHUGJUNIE0QL5ZOMIIYOZX3J2KB"
      secret = "D2RJSPBWSEO5PRNQBF1IQ1S001PLYSHMUSM02RHGS2XFNRHS"

      client = FoursquareHelper.create_client(id, secret)

      {message, token} = FoursquareHelper.get_token(client)
      Repo.insert(%Token{
        service: "foursquare",
        access_token: token.access_token,
        token_type: token.token_type,
        expires_at: token.expires_at
      })

      token
    else
      db_token
    end
  end

  def topplaces(conn, %{"latitude" => lat, "longitude" => long, "query" => query} = params) do

    request_url = "https://api.foursquare.com/v2/venues/explore?ll=#{lat},#{long}&query=#{query}&client_id=TBYPUBXPXKEI1LF3SFWUWLHUGJUNIE0QL5ZOMIIYOZX3J2KB&client_secret=D2RJSPBWSEO5PRNQBF1IQ1S001PLYSHMUSM02RHGS2XFNRHS&v=20180131"

    headers = []

    response = HTTPoison.get!(request_url, headers)

    body = Poison.decode!(response.body)

    businesses = Map.get(body, "venue")

    if businesses == [] do
      json conn, "No places found near those coordinates."
    end

    json conn, body
  end

  def topplaces(conn, %{"latitude" => lat, "longitude" => long} = params) do


    IO.inspect("calling the right function?")
    request_url = "https://api.foursquare.com/v2/venues/explore?ll=#{lat},#{long}&client_id=TBYPUBXPXKEI1LF3SFWUWLHUGJUNIE0QL5ZOMIIYOZX3J2KB&client_secret=D2RJSPBWSEO5PRNQBF1IQ1S001PLYSHMUSM02RHGS2XFNRHS&v=20180131"

    headers = []

    response = HTTPoison.get!(request_url, headers)

    body = Poison.decode!(response.body)

    businesses = Map.get(body, "venue")

    if businesses == [] do
      json conn, "No places found near those coordinates."
    end

    json conn, body
  end

  def topplaces(conn, %{"near" => location, "query" => query} = params) do

    request_url = "https://api.foursquare.com/v2/venues/explore?near=#{location}&query=#{query}&client_id=TBYPUBXPXKEI1LF3SFWUWLHUGJUNIE0QL5ZOMIIYOZX3J2KB&client_secret=D2RJSPBWSEO5PRNQBF1IQ1S001PLYSHMUSM02RHGS2XFNRHS&v=20180131"
    headers = []

    response = HTTPoison.get!(request_url, headers)

    body = Poison.decode!(response.body)

    if body == "null" do
      json conn, "No businesses found near those coordinates."
    end

    json conn, body
  end

  def topplaces(conn, %{"near" => location} = params) do

    request_url = "https://api.foursquare.com/v2/venues/explore?near=#{location}&client_id=TBYPUBXPXKEI1LF3SFWUWLHUGJUNIE0QL5ZOMIIYOZX3J2KB&client_secret=D2RJSPBWSEO5PRNQBF1IQ1S001PLYSHMUSM02RHGS2XFNRHS&v=20180131"

    headers = []
    response = HTTPoison.get!(request_url, headers)

    body = Poison.decode!(response.body)

    if body == "null" do
      json conn, "No places found near those coordinates."
    end

    json conn, body
  end

end
