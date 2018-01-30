defmodule PlanIt.SuggestionsController do

  use PlanIt.Web, :controller
  use HTTPoison.Base
  alias OAuth2
  alias PlanIt.Card
  alias PlanIt.YelpHelper
  alias PlanIt.Repo
  alias PlanIt.Token

  @yelp_url "https://api.yelp.com/v3/"
  @foursquare_url "https://api.foursquare.com/v2/"


  def index(conn, _params) do
    json conn, "ok"
  end

  def get_token() do

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

  def topplaces(conn, %{"latitude" => lat, "longitude" => long, "categories" => categories} = params) do

    yelp_token = get_token()

    yelp_url = "https://api.yelp.com/v3/businesses/search?latitude=#{lat}&longitude=#{long}&categories=#{categories}"
    yelp_headers = ["Authorization": "#{yelp_token.token_type} #{yelp_token.access_token}"]
    yelp_response = HTTPoison.get!(yelp_url, yelp_headers)
    yelp_body = Poison.decode!(yelp_response.body)
    yelp_businesses = Map.get(yelp_body, "businesses")

    foursquare_url = "https://api.foursquare.com/v2/venues/explore?client_id=NKGVGUKE0KSZBAQC2M0MYIX1U0MSU31VSTNTWYPGJ4VW0TQF&client_secret=KVZEVGPA3T4523RGDNX32UH1Y33OXZHJYCWPULNES1VIPUWT&v=2220170801&ll=#{lat},#{long}&query=#{categories}"
    foursquare_headers = []
    foursquare_response = HTTPoison.get!(foursquare_url, foursquare_headers)
    foursquare_businesses = Poison.decode!(foursquare_response.body)

    if yelp_businesses == [] or foursquare_businesses == "null" do
      json conn, "No places found near those coordinates."
    end

    json conn, yelp_businesses + foursquare_businesses

  end

  def topplaces(conn, %{"latitude" => lat, "longitude" => long} = params) do

    yelp_token = get_token()

    yelp_url = "https://api.yelp.com/v3/businesses/search?latitude=#{lat}&longitude=#{long}"
    yelp_headers = ["Authorization": "#{yelp_token.token_type} #{yelp_token.access_token}"]
    yelp_response = HTTPoison.get!(yelp_url, yelp_headers)
    yelp_body = Poison.decode!(yelp_response.body)
    yelp_businesses = Map.get(yelp_body, "businesses")

    foursquare_url = "https://api.foursquare.com/v2/venues/explore?client_id=NKGVGUKE0KSZBAQC2M0MYIX1U0MSU31VSTNTWYPGJ4VW0TQF&client_secret=KVZEVGPA3T4523RGDNX32UH1Y33OXZHJYCWPULNES1VIPUWT&v=2220170801&ll=#{lat},#{long}"
    foursquare_headers = []
    foursquare_response = HTTPoison.get!(foursquare_url, foursquare_headers)
    foursquare_businesses = Poison.decode!(foursquare_response.body)

    if yelp_businesses == [] or foursquare_businesses == "null" do
      json conn, "No places found near those coordinates."
    end

    json conn, [yelp_businesses, foursquare_businesses]

  end

end
