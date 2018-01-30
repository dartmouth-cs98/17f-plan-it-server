defmodule PlanIt.RoomChannel do
  use Phoenix.Channel
  alias PlanIt.CardController
  alias PlanIt.CardUtil

  def join("rooms:lobby", _message, socket) do
    {:ok, socket}
  end

  def join(_room, _params, _socket) do
    {:error, %{reason: "You can only join the lobby"}}
  end

  def handle_in("new:msg", body, socket) do
    IO.inspect("New message in")
    broadcast! socket, "new:msg", body
    {:noreply, socket}
  end

  def handle_in("new:msg:cards", body, socket) do
    IO.inspect("new message:cards")
    body = Map.get(body, "body")
    trip_id = Map.get(body, "tripId")
    cards = Map.get(body, "cards")

    #CardUtil.create_update_helper(Map.get(body, "tripId"), Map.get(body, "cards"))
    {message, ret_package} = CardUtil.create_update_helper(trip_id, cards)

    #Scrub the ret package
    ret_package = Enum.map(ret_package, fn(c) ->
      c
      |> Map.drop([:__meta__, :__struct__, :trip])
    end)

    broadcast! socket, "new:msg:cards", %{cards: ret_package}
    {:noreply, socket}
  end

  def handle_in("new:user", body, socket) do
    IO.inspect("New user in")
    IO.inspect(socket)
    IO.inspect(body)
    broadcast! socket, "new:user", body
    {:noreply, socket}
  end


end
