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

    foursquare_url = "https://api.foursquare.com/v2/venues/explore?client_id=NKGVGUKE0KSZBAQC2M0MYIX1U0MSU31VSTNTWYPGJ4VW0TQF&client_secret=KVZEVGPA3T4523RGDNX32UH1Y33OXZHJYCWPULNES1VIPUWT&v=2220170801&ll=#{lat},#{long}&query=#{categories}&venuePhotos=1"
    foursquare_headers = []
    foursquare_response = HTTPoison.get!(foursquare_url, foursquare_headers)
    foursquare_businesses = Poison.decode!(foursquare_response.body)

    if yelp_businesses == [] or foursquare_businesses == "null" do
      json conn, "No places found near those coordinates."
    end

    formartted_yelp_business = Enum.map(yelp_businesses, fn(yelp_business) -> formatYelp(yelp_business) end)

    json conn, [yelp_businesses, foursquare_businesses]

  end

  def topplaces(conn, %{"latitude" => lat, "longitude" => long} = params) do

    yelp_token = get_token()

    yelp_url = "https://api.yelp.com/v3/businesses/search?latitude=#{lat}&longitude=#{long}"
    yelp_headers = ["Authorization": "#{yelp_token.token_type} #{yelp_token.access_token}"]
    yelp_response = HTTPoison.get!(yelp_url, yelp_headers)
    yelp_body = Poison.decode!(yelp_response.body)
    yelp_businesses = Map.get(yelp_body, "businesses")

    foursquare_url = "https://api.foursquare.com/v2/venues/explore?client_id=NKGVGUKE0KSZBAQC2M0MYIX1U0MSU31VSTNTWYPGJ4VW0TQF&client_secret=KVZEVGPA3T4523RGDNX32UH1Y33OXZHJYCWPULNES1VIPUWT&v=2220170801&ll=#{lat},#{long}&venuePhotos=1"
    foursquare_headers = []
    foursquare_response = HTTPoison.get!(foursquare_url, foursquare_headers)
    foursquare_businesses = Poison.decode!(foursquare_response.body)

    if yelp_businesses == [] or foursquare_businesses == "null" do
      json conn, "No places found near those coordinates."
    end

    formatted_yelp_businesses = Enum.map(yelp_businesses, fn(yelp_business) -> formatYelp(yelp_business) end)

    IO.inspect(foursquare_businesses["response"]["groups"])
    # format1 = Enum.get()
    # IO.inspect(format1)
    formatted_foursquare_businesses = Enum.map(foursquare_businesses, fn(foursquare_business) -> formatFoursquare(foursquare_business) end)
    # IO.inspect(formatted_yelp_businesses)

    json conn, formatted_yelp_businesses

    # //, foursquare_businesses

  end

  def formatYelp(suggestion) do

    business = %{
      name: suggestion["name"],
      image_url: suggestion["image_url"],
      url: suggestion["url"],
      price: suggestion["price"],
      lat: suggestion["coordinates"]["latitude"],
      long: suggestion["coordinates"]["longitude"],
      address: suggestion["location"]["address1"],
      city: suggestion["location"]["city"],
      state: suggestion["location"]["state"],
      country: suggestion["location"]["country"],
      zip_code: suggestion["location"]["zip_code"],
      phone: suggestion["phone"],
      display_phone: suggestion["display_phone"],

      description: Map.get(suggestion, "categories") |> Enum.at(0) |> Map.get("title"),
     
      source: "yelp"
    }

  end

  def formatFoursquare(suggestion) do

    IO.inspect(suggestion)

    business = %{
      name: suggestion["venue"]["name"],
      image_url: suggestion["image_url"],
      url: suggestion["url"],
      price: suggestion["price"],
      lat: suggestion["coordinates"]["latitude"],
      long: suggestion["coordinates"]["longitude"],
      address: suggestion["location"]["address1"],
      city: suggestion["location"]["city"],
      state: suggestion["location"]["state"],
      country: suggestion["location"]["country"],
      zip_code: suggestion["location"]["zip_code"],
      phone: suggestion["phone"],
      display_phone: suggestion["display_phone"],

      description: Map.get(suggestion, "categories") |> Enum.at(0) |> Map.get("title"),
     
      source: "yelp"
    }

  end

end
