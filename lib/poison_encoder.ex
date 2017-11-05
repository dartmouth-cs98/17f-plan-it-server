defimpl Poison.Encoder, for: Any do
  def encode(%{__struct__: _} = struct, options) do
    map = struct
          |> Map.from_struct
          |> sanitize_map
          |> sanitize_user
          |> sanitize_trip
    Poison.Encoder.Map.encode(map, options)
  end

  defp sanitize_map(map) do
    Map.drop(map, [:__meta__, :__struct__])
  end

  defp sanitize_user(map) do
    Map.drop(map, [:trip])
  end

  defp sanitize_trip(map) do
    Map.drop(map, [:card, :user, :favorited_trip])
  end
end
