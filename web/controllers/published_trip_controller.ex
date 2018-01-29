defmodule PlanIt.PublishedTripController do
  alias PlanIt.Repo
  alias PlanIt.Card
  alias PlanIt.Trip
  alias PlanIt.FavoritedTrip
  import Ecto.Query

  use PlanIt.Web, :controller


  # GET - get published trips ordered by parameter
  def index(conn, %{"order" => order } = params) do

    trips = 
	    case order do
	      nil ->
	      	  json put_status(conn, 400), "no ordering provided"

	      "popular" ->
		      (from t in PlanIt.Trip,
		        where: t.publish == true,
		        select: t,
		        order_by: [desc: :upvotes]
		      ) |> Repo.all

	      "publish_date" ->
		      (from t in PlanIt.Trip,
		        where: t.publish == true,
		        select: t,
		        order_by: [desc: :inserted_at]
		      ) |> Repo.all

	      "trending" ->
		       (from ft in PlanIt.FavoritedTrip, 
		                left_join: t in PlanIt.Trip, 
		                on: ft.trip_id == t.id, 
		                where: t.publish == true, 
		                select: ft,
		                order_by: [desc: :inserted_at]
		        ) |> Repo.all

	        _ ->
	      		json put_status(conn, 400), "Invalid ordering provided. 
	      		Valid orderings are 'popular', 'publish_date', and 'trending'"
	    end



    IO.inspect(trips)

    json conn, trips
  end

end
