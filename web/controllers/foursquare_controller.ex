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

  def topplaces(conn, %{"latitude" => lat, "longitude" => long, "categories" => query} = params) do

    request_url = "https://api.foursquare.com/v2/venues/explore?client_id=NKGVGUKE0KSZBAQC2M0MYIX1U0MSU31VSTNTWYPGJ4VW0TQF&client_secret=KVZEVGPA3T4523RGDNX32UH1Y33OXZHJYCWPULNES1VIPUWT&v=2220170801&ll=#{lat},#{long}&query=#{query}"

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


    request_url = "https://api.foursquare.com/v2/venues/explore?client_id=NKGVGUKE0KSZBAQC2M0MYIX1U0MSU31VSTNTWYPGJ4VW0TQF&client_secret=KVZEVGPA3T4523RGDNX32UH1Y33OXZHJYCWPULNES1VIPUWT&v=2220170801&ll=#{lat},#{long}"

    headers = []

    response = HTTPoison.get!(request_url, headers)

    body = Poison.decode!(response.body)

    businesses = Map.get(body, "venue")

    if businesses == [] do
      json conn, "No places found near those coordinates."
    end

    json conn, body
  end

  def topplaces(conn, %{"near" => location, "categories" => query} = params) do

    request_url = "https://api.foursquare.com/v2/venues/explore?client_id=NKGVGUKE0KSZBAQC2M0MYIX1U0MSU31VSTNTWYPGJ4VW0TQF&client_secret=KVZEVGPA3T4523RGDNX32UH1Y33OXZHJYCWPULNES1VIPUWT&v=2220170801&near=#{location}&query=#{query}"

    headers = []

    response = HTTPoison.get!(request_url, headers)

    body = Poison.decode!(response.body)

    if body == "null" do
      json conn, "No businesses found near those coordinates."
    end

    json conn, body
  end

  def topplaces(conn, %{"near" => location} = params) do

    request_url = "https://api.foursquare.com/v2/venues/explore?client_id=NKGVGUKE0KSZBAQC2M0MYIX1U0MSU31VSTNTWYPGJ4VW0TQF&client_secret=KVZEVGPA3T4523RGDNX32UH1Y33OXZHJYCWPULNES1VIPUWT&v=2220170801&near=#{location}"

    headers = []
    response = HTTPoison.get!(request_url, headers)

    body = Poison.decode!(response.body)

    if body == "null" do
      json conn, "No places found near those coordinates."
    end

    json conn, body
  end

end
