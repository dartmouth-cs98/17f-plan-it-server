defmodule PlanIt.UserSocket do
  use Phoenix.Socket 

  transport :websocket, Phoenix.Transports.WebSocket,
    timeout: 45_000

end