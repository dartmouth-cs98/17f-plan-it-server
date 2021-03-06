defmodule PlanIt.SuggestionsController do

  use PlanIt.Web, :controller
  use HTTPoison.Base
  alias OAuth2
  alias PlanIt.Card
  alias PlanIt.YelpHelper
  alias PlanIt.Repo
  alias PlanIt.Token
  alias PlanIt.Trip

  @yelp_url "https://api.yelp.com/v3/"
  @foursquare_url "https://api.foursquare.com/v2/"
  @yelp_api_key "KDaVXonk-dL80tzpL1QjopM7LfAsb7Lf-xFvhdz6-66hJOCozyYt2SJdua2llL_L_Cc1Jqve5xaAEI6GiIpc35Y73qcvb_xqys2PnXNUgL-9EVgDo-zMcKDc9nWYWnYx"


  def index(conn, _params) do
    json conn, "ok"
  end

  def topplaces(conn, %{"latitude" => lat, "longitude" => long, "categories" => categories} = params) do

    yelp_url = "https://api.yelp.com/v3/businesses/search?latitude=#{lat}&longitude=#{long}&categories=#{categories}"
    yelp_headers = ["Authorization": "Bearer #{@yelp_api_key}"]
    yelp_response = HTTPoison.get!(yelp_url, yelp_headers)
    yelp_body = Poison.decode!(yelp_response.body)
    yelp_businesses = Map.get(yelp_body, "businesses")

    client_id = "NKGVGUKE0KSZBAQC2M0MYIX1U0MSU31VSTNTWYPGJ4VW0TQF"
    client_secret = "KVZEVGPA3T4523RGDNX32UH1Y33OXZHJYCWPULNES1VIPUWT"
    foursquare_url = "https://api.foursquare.com/v2/venues/explore?client_id=#{client_id}&client_secret=#{client_secret}&v=2220170801&ll=#{lat},#{long}&query=#{categories}&venuePhotos=1&limit=15"
    foursquare_headers = []
    foursquare_response = HTTPoison.get!(foursquare_url, foursquare_headers)
    foursquare_businesses = Poison.decode!(foursquare_response.body)

    if yelp_businesses == [] and foursquare_businesses == nil do
      json conn, "No places found near those coordinates."
    end

    formatted_yelp_businesses = Enum.map(yelp_businesses, fn(yelp_business) -> formatYelp(yelp_business) end)
    foursquare_parsed = foursquare_businesses["response"]["groups"] |> Enum.at(0) |> Map.get("items")
    formatted_foursquare_businesses = Enum.map(foursquare_parsed, fn(suggestion) -> formatFoursquare(suggestion) end)

    # concat yelp and foursquare
    yelp_and_foursquare = formatted_yelp_businesses ++ formatted_foursquare_businesses

    # put the formatted suggestions in a dictionary, removing duplicates; latest one prevails
    phone_number_dict = Map.new(yelp_and_foursquare, fn(suggestion) -> {suggestion.phone, suggestion} end)

    json conn, Map.values(phone_number_dict)
  end

  def topplaces(conn, %{"latitude" => lat, "longitude" => long} = params) do

    yelp_url = "https://api.yelp.com/v3/businesses/search?latitude=#{lat}&longitude=#{long}"
    yelp_headers = ["Authorization": "Bearer #{@yelp_api_key}"]
    yelp_response = HTTPoison.get!(yelp_url, yelp_headers)
    yelp_body = Poison.decode!(yelp_response.body)
    yelp_businesses = Map.get(yelp_body, "businesses")

    client_id = "NKGVGUKE0KSZBAQC2M0MYIX1U0MSU31VSTNTWYPGJ4VW0TQF"
    client_secret = "KVZEVGPA3T4523RGDNX32UH1Y33OXZHJYCWPULNES1VIPUWT"

    foursquare_url = "https://api.foursquare.com/v2/venues/explore?client_id=#{client_id}&client_secret=#{client_secret}&v=2220170801&ll=#{lat},#{long}&venuePhotos=1&limit=15"
    foursquare_headers = []
    foursquare_response = HTTPoison.get!(foursquare_url, foursquare_headers)
    foursquare_businesses = Poison.decode!(foursquare_response.body)

    if yelp_businesses == [] and foursquare_businesses == nil do
      json conn, "No points of interest found near those coordinates."
    end

    formatted_yelp_businesses = Enum.map(yelp_businesses, fn(suggestion) -> formatYelp(suggestion) end)
    foursquare_parsed = foursquare_businesses["response"]["groups"] |> Enum.at(0) |> Map.get("items")
    formatted_foursquare_businesses = Enum.map(foursquare_parsed, fn(suggestion) -> formatFoursquare(suggestion) end)

    # concat yelp and foursquare
    yelp_and_foursquare = formatted_yelp_businesses ++ formatted_foursquare_businesses

    # put the formatted suggestions in a dictionary, removing duplicates; latest one prevails
    phone_number_dict = Map.new(yelp_and_foursquare, fn(suggestion) -> {suggestion.phone, suggestion} end)

    json conn, Map.values(phone_number_dict)

  end


  def topplaces(conn, %{"latitude" => lat, "longitude" => long, "trip_id" => trip_id} = params) do

    yelp_url = "https://api.yelp.com/v3/businesses/search?latitude=#{lat}&longitude=#{long}"
    yelp_headers = ["Authorization": "Bearer #{@yelp_api_key}"]
    yelp_response = HTTPoison.get!(yelp_url, yelp_headers)
    yelp_body = Poison.decode!(yelp_response.body)
    yelp_businesses = Map.get(yelp_body, "businesses")

    client_id = "NKGVGUKE0KSZBAQC2M0MYIX1U0MSU31VSTNTWYPGJ4VW0TQF"
    client_secret = "KVZEVGPA3T4523RGDNX32UH1Y33OXZHJYCWPULNES1VIPUWT"

    foursquare_url = "https://api.foursquare.com/v2/venues/explore?client_id=#{client_id}&client_secret=#{client_secret}&v=2220170801&ll=#{lat},#{long}&venuePhotos=1&limit=15"
    foursquare_headers = []
    foursquare_response = HTTPoison.get!(foursquare_url, foursquare_headers)
    foursquare_businesses = Poison.decode!(foursquare_response.body)

    if yelp_businesses == [] and foursquare_businesses == nil do
      json conn, "No points of interest found near those coordinates."
    end

    formatted_yelp_businesses = Enum.map(yelp_businesses, fn(suggestion) -> formatYelp(suggestion) end)
    foursquare_parsed = foursquare_businesses["response"]["groups"] |> Enum.at(0) |> Map.get("items")
    formatted_foursquare_businesses = Enum.map(foursquare_parsed, fn(suggestion) -> formatFoursquare(suggestion) end)

    # concat yelp and foursquare
    yelp_and_foursquare = formatted_yelp_businesses ++ formatted_foursquare_businesses

    # put the formatted suggestions in a dictionary, removing duplicates; latest one prevails
    phone_number_dict = Map.new(yelp_and_foursquare, fn(suggestion) -> {suggestion.phone, suggestion} end)

    suggestion_cards = Map.values(phone_number_dict)

    custom_cards = (from c in Card,
          where: c.trip_id == ^trip_id and c.queue == true,
          select: c,
          order_by: [asc: :start_time]
    ) |> Repo.all

    json conn, suggestion_cards ++ custom_cards

  end


  def formatYelp(s) do

    business = %{
      name: s["name"],
      photo_url: s["image_url"],
      url: s["url"],
      price: s["price"],
      rating: "#{s["rating"]}" <> "/5",
      lat: s["coordinates"]["latitude"],
      long: s["coordinates"]["longitude"],
      address: s["location"]["address1"],
      city: s["location"]["city"],
      state: s["location"]["state"],
      country: s["location"]["country"],
      zip_code: s["location"]["zip_code"],
      phone: take_countrycode(s["phone"]),
      type: Map.get(s, "categories") |> Enum.at(0) |> Map.get("title"),
      description: Map.get(s, "categories") |> Enum.at(0) |> Map.get("title"),
      source: "Yelp"
    }

  end

  def formatFoursquare(suggestion) do

    s = suggestion["venue"]

    # Check for nil in long pipe; might raise an error otherwise
    if not is_map(Map.get(s, "photos") |> Map.get("groups") |> Enum.at(0)) do
      photo_url = nil
    else
      prefix = Map.get(s, "photos") |> Map.get("groups") |> Enum.at(0) |> Map.get("items") |> Enum.at(0) |> Map.get("prefix")
      suffix = Map.get(s, "photos") |> Map.get("groups") |> Enum.at(0) |> Map.get("items") |> Enum.at(0) |> Map.get("suffix")
      photo_size = "original"
      photo_url = prefix <> photo_size <> suffix
    end

    business = %{
      name: s["name"],
      photo_url: photo_url,
      url: "www.foursquare.com/v/" <> s["id"],
      price: s["price"]["currency"],
      rating: "#{s["rating"]}" <> "/10",
      lat: s["location"]["lat"],
      long: s["location"]["lng"],
      address: s["location"]["address"],
      city: s["location"]["city"],
      state: s["location"]["state"],
      country: s["location"]["country"],
      zip_code: s["location"]["postalCode"],
      phone: take_countrycode(s["contact"]["phone"]),
      type: Map.get(s, "categories") |> Enum.at(0) |> Map.get("shortName"),
      description: Map.get(s, "categories") |> Enum.at(0) |> Map.get("shortName"),
      source: "Foursquare"
    }

  end

  def take_countrycode(phone_number) do

    if phone_number != "" and phone_number != nil and String.length(phone_number) >= 10 do
      String.slice(phone_number, String.length(phone_number)-10..-1)

    else
      phone_number
    end
  end
end
