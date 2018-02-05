defmodule PlanIt.PublishedTripController do
  alias PlanIt.Repo
  alias PlanIt.Card
  alias PlanIt.Trip
  alias PlanIt.FavoritedTrip
  alias PlanIt.ViewedTrip
  import Ecto.Query

  use PlanIt.Web, :controller

  # GET - get published trips in order of most recently viewed by a particular user
  def index(conn, %{"order" => order, "user_id" => user_id} = params) do
  	
  	if order != "user_recent" do
  		json put_status(conn, 400), "invalid ordering provided"

  	else 
  		trips = (from vt in PlanIt.ViewedTrip,
			left_join: t in PlanIt.Trip,
			on: vt.trip_id == t.id,
			where: t.publish == true and vt.user_id == ^user_id,
			select: %{id: t.id,
				user_id: t.user_id,
				name: t.name,
				upvotes: t.upvotes,
				downvotes: t.downvotes,
				photo_url: t.photo_url,
				publish: t.publish, 
				start_time: t.start_time,
				end_time: t.end_time,
				last_visited: vt.last_visited,
				inserted_at: vt.inserted_at,
				updated_at: vt.updated_at},
			order_by: [desc: :last_visited]
		) |> Repo.all

		json conn, trips
  	end
  end

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
	                select: %{id: t.id,
                        user_id: t.user_id,
                        name: t.name,
                        upvotes: t.upvotes,
                        downvotes: t.downvotes,
                        photo_url: t.photo_url,
                        publish: t.publish,
                        start_time: t.start_time,
                        end_time: t.end_time,
                        last_visited: ft.last_visited,
                        inserted_at: ft.inserted_at,
                        updated_at: ft.updated_at},
                	order_by: [desc: :inserted_at]
		        ) |> Repo.all

	        _ ->
	      	 	json put_status(conn, 400), "Invalid ordering provided. Valid orderings are 'popular', 'publish_date', and 'trending'"
	    end

    json conn, trips

  end

  # GET - get published trips in no particular order
  def index(conn, _params) do

    trips = (from t in PlanIt.Trip,
		        where: t.publish == true,
		        select: t
		      ) |> Repo.all

    json conn, trips

  end

end
