defmodule PlanIt.UserController do
  alias PlanIt.Repo
  alias PlanIt.User
  alias PlanIt.Card
  alias PlanIt.Trip
  alias PlanIt.FavoritedTrip
  alias PlanIt.EditPermission

  use PlanIt.Web, :controller

  import Ecto.Changeset

  # GET - get all users in the database
  def index(conn, _params) do
    users = PlanIt.User |> Repo.all
    json conn, users
  end

  # GET - get a user by id
  def show(conn, %{"id" => user_id} = params) do
    user = (from u in User,
      where: u.id == ^user_id,
      select: u
    ) |> Repo.one

    json conn, user
  end

  # POST - insert a new user
  def create(conn, params) do
    email = Map.get(params, "email")

    id = (from u in User,
        where: u.email == ^email,
        select: u.id
      ) |> Repo.one

    if id != nil do
      json conn, id
    else
      changeset = User.changeset(%User{}, params)
      {message, changeset} = Repo.insert(changeset)

      if message == :error do
        error = "error: #{inspect changeset.errors}"
        json put_status(conn, 400), error
      end

      json conn, changeset.id
    end
  end

  # PUT - update an existing user
  def update(conn, %{"id" => user_id} = params) do
    user = Repo.get(User, user_id)
    changeset = User.changeset(user, params)

    {message, changeset} = Repo.update(changeset)

    if message == :error do
      error = "error: #{inspect changeset.errors}"
      json put_status(conn, 400), error
    end

    json conn, "ok"
  end

  # GET - inserts sample data
  def create_sample(conn, _params) do

    Repo.insert!(%User{
      fname: "Sam",
      lname: "Lee",
      email: "samlee@example.com",
      username: "slee",
      birthday: ~D[1996-12-31]})

    Repo.insert!(%User{
      fname: "John",
      lname: "Doe",
      email: "jd@example.com",
      username: "johndoe",
      birthday: ~D[1996-01-01]})


    Repo.insert!(%Trip{
      name: "Hanover Vacation",
      publish: true,
      photo_url: "https://www.dartmouth.edu/~library/bakerberry/images/bb5.jpg",
      user_id: 1,
      start_time: DateTime.from_naive!(~N[2018-05-24 00:00:00], "Etc/UTC"),
      end_time: DateTime.from_naive!(~N[2018-05-26 00:00:00], "Etc/UTC"),
      upvotes: 5
    })
    Repo.insert!(%Trip{
      name: "Turlock Trip",
      publish: true,
      photo_url: "https://blogjob.com/lifeandliving/files/2014/08/Turlock-california.jpg",
      user_id: 1,
      upvotes: 10
    })
    Repo.insert!(%Trip{
      name: "Seoul Eating Adventure",
      publish: false,
      photo_url: "http://lh4.ggpht.com/_9ZFZVn5T9O0/Sv_zi5UJbII/AAAAAAAAbR8/_-2Mo20VoX0/s400/IMG_1348.JPG",
      user_id: 2
    })

    Repo.insert!(%Card{
      type: "restaurant",
      name: "Lou's",
      city: "Hanover",
      country: "USA",
      address: "Main street",
      lat: 43.7015182,
      long: -72.2914068,
      start_time: DateTime.from_naive!(~N[2018-05-24 13:26:08.003], "Etc/UTC"),
      end_time: DateTime.from_naive!(~N[2018-05-24 14:26:08.003], "Etc/UTC"),
      day_number: 1,
      trip_id: 1,
      description: "Breakfast restaurant",
      photo_url: "http://www.billrooneystudio.com/brimages/pine_wed_1a_001.jpg",
      url: "https://www.yelp.com/biz/pine-restaurant-hanover-2"
    })

    Repo.insert!(%Card{
      type: "exercise",
      name: "Alumni Gym",
      city: "Hanover",
      country: "USA",
      address: "In front of East Wheelock",
      lat: 43.7028954,
      long: -72.2861988,
      start_time: DateTime.from_naive!(~N[2018-05-24 15:26:08.003], "Etc/UTC"),
      end_time: DateTime.from_naive!(~N[2018-05-24 16:26:08.003], "Etc/UTC"),
      day_number: 1,
      trip_id: 1,
      description: "Largest gym in Hanover",
      photo_url: "http://image.cdnllnwnl.xosnetwork.com/pics33/640/MY/MYUWEHDGHFRUPUW.20151015131030.jpg",
      travel_type: "bike",
      travel_duration: 900
    })

    Repo.insert!(%Card{
      type: "restaurant",
      name: "Pine",
      city: "Hanover",
      country: "USA",
      address: "By Main Street",
      lat: 43.7022265,
      long: -72.2913434,
      start_time: DateTime.from_naive!(~N[2018-05-25 12:26:08.003], "Etc/UTC"),
      end_time: DateTime.from_naive!(~N[2018-05-25 13:26:08.003], "Etc/UTC"),
      day_number: 2,
      trip_id: 1,
      description: "Nice restaurant",
      photo_url: "http://image.cdnllnwnl.xosnetwork.com/pics33/640/MY/MYUWEHDGHFRUPUW.20151015131030.jpg",
      travel_type: "bike",
      travel_duration: 900
    })

    Repo.insert!(%FavoritedTrip{user_id: 1, trip_id: 3, last_visited: Ecto.DateTime.utc, trip_name: "Fave trip 1"})
    Repo.insert!(%FavoritedTrip{user_id: 2, trip_id: 1, last_visited: Ecto.DateTime.utc, trip_name: "Fave trip 2"})
    Repo.insert!(%FavoritedTrip{user_id: 1, trip_id: 2, last_visited: Ecto.DateTime.utc, trip_name: "Fave trip 3"})

    Repo.insert!(%EditPermission{user_id: 1, trip_id: 1})
    Repo.insert!(%EditPermission{user_id: 1, trip_id: 2})
    Repo.insert!(%EditPermission{user_id: 2, trip_id: 3})


    json conn, []
  end
end
