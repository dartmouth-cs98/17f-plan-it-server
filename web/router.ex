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

  scope "/api/v1", PlanIt do
    pipe_through :api

    resources "/users", UserController, only: [:index, :show, :create, :update]
    get "/createsample", UserController, :create_sample

    resources "/trips", TripController, only: [:index, :show, :create, :update, :delete] do
      get "/upvote", TripController, :upvote
      get "/downvote", TripController, :downvote
    end

    resources "/cards", CardController, only: [:index, :create, :update, :delete]

    resources "/permissions", EditPermissionController, only: [:index, :create]
    delete "/permissions", EditPermissionController, :remove

    resources "/favorited", FavoritedTripController, only: [:index, :create]
    put "/favorited", FavoritedTripController, :change
    delete "/favorited", FavoritedTripController, :remove

    resources "/published", PublishedTripController, only: [:index]

    resources "/viewed", ViewedTripController, only: [:index, :create]
    put "/viewed", ViewedTripController, :change

    get "/yelp", YelpController, :topplaces
    get "/foursquare", FoursquareController, :topplaces
  end

end
