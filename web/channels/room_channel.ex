defmodule PlanIt.RoomChannel do
  use Phoenix.Channel
  alias PlanIt.CardController
  alias PlanIt.CardUtil

  #Let them join any room
  def join(room, _message, socket) do
    {:ok, socket}
  end

  def handle_in("new:msg", body, socket) do
    IO.inspect("New message in")
    broadcast! socket, "new:msg", body
    {:noreply, socket}
  end

  def handle_in("new:msg:cards", body, socket) do
    body = Map.get(body, "body")
    trip_id = Map.get(body, "tripId")
    cards = Map.get(body, "cards")

    #CardUtil.create_update_helper(Map.get(body, "tripId"), Map.get(body, "cards"))
    {message, ret_package} = CardUtil.create_update_helper(trip_id, cards)

    #Scrub the ret package
    ret_package = Enum.map(ret_package, fn(c) ->
      Map.drop(c, [:__meta__, :__struct__, :trip])
    end)

    broadcast! socket, "new:msg:cards", %{cards: ret_package}
    {:noreply, socket}
  end

  def handle_in("new:user", body, socket) do
    IO.inspect("New user in")
    broadcast! socket, "new:user:enter", body
    {:noreply, socket}
  end


end
