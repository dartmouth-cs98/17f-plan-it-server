defmodule PlanIt.RoomChannel do
  use Phoenix.Channel

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

  def handle_in("new:user", body, socket) do
    IO.inspect("New user in")
    broadcast! socket, "new:user", body
    {:noreply, socket}
  end


end
