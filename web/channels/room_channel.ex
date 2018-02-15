defmodule PlanIt.RoomChannel do
  use Phoenix.Channel

  import Ecto.Query
  alias PlanIt.CardController
  alias PlanIt.CardUtil
  alias PlanIt.Repo
  alias PlanIt.User

  #Let them join any room
  # Anon users will have a uuid email. No anon sockets
  def join(room, message, socket) do
    email = Map.get(message, "email")
    user = (from u in User,
      where: u.email == ^email,
      select: u ) |> Repo.one

      if user do
        socket = socket
          |> assign(:email, email)
          |> assign(:fname, user.fname)
          |> assign(:lname, user.lname)
      else
        socket = socket
          |> assign(:email, email)
          |> assign(:fname, "a")
          |> assign(:lname, "a")
      end

    {:ok, socket}
  end

  def handle_in("new:msg", body, socket) do
    IO.inspect("New message in")
    broadcast! socket, "new:msg", body
    {:noreply, socket}
  end

  def handle_in("new:msg:cards", body, socket) do

    body = Map.get(body, "body")
    {message, ret_package} = CardUtil.create_update_helper(Map.get(body, "tripId"), Map.get(body, "cards"))

    #Scrub the ret package
    ret_package = Enum.map(ret_package, fn(c) ->
      Map.drop(c, [:__meta__, :__struct__, :trip])
    end)

    broadcast! socket, "new:msg:cards", %{cards: ret_package}
    {:noreply, socket}
  end

  def handle_in("new:user:enter", body, socket) do
    IO.inspect("New user in")
    broadcast! socket, "new:user:enter", body
    {:noreply, socket}
  end

  def handle_in("new:user:exit", body, socket) do
    IO.inspect("User left")
    broadcast! socket, "new:user:exit", body
    {:noreply, socket}
  end

  #heartbeat
  def handle_in("new:user:heartbeat", body, socket) do
    #IO.inspect("Heartbeat received")
    #IO.inspect(socket)

    broadcast! socket, "new:user:heartbeat", socket.assigns
    {:noreply, socket}
  end

  def handle_in(msg, body, socket) do
    IO.inspect("Catch all")
    {:noreply, socket}
   end

end
