defmodule PlanIt.Router do
  use PlanIt.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PlanIt do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/api/v2", PlanIt do
    pipe_through :api

    resources "/users", UserController, only: [:index, :show, :create, :update]
    get "/createsample", UserController, :create_sample

    resources "/trips", TripController, only: [:index, :show, :create, :update, :delete] do
      get "/upvote", TripController, :upvote
      get "/downvote", TripController, :downvote
    end

    resources "/cards/itinerary", ItineraryCardController, only: [:index, :create, :update, :delete]
    resources "/cards/queue", QueueCardController, only: [:index, :create, :update, :delete]

    resources "/permissions", EditPermissionController, only: [:index, :create]
    delete "/permissions", EditPermissionController, :remove

    resources "/favorited", FavoritedTripController, only: [:index, :create]
    delete "/favorited", FavoritedTripController, :remove

    resources "/published", PublishedTripController, only: [:index]

    resources "/viewed", ViewedTripController, only: [:index, :create]

    get "/yelp", YelpController, :topplaces
    get "/foursquare", FoursquareController, :topplaces
    get "/suggestions", SuggestionsController, :topplaces

    get "/sharecode", ShareCodeController, :index

  end

end
