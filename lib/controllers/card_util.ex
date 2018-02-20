defmodule PlanIt.CardUtil do
  alias PlanIt.Repo
  alias PlanIt.Card

  import Ecto.Query
  import Ecto.Changeset

  def create_update_helper(trip_id, cards) do
    new_card = Enum.find(cards, fn(c) -> Map.get(c, "id") == 0 end)
    if new_card != nil do
      {new_card_status, new_card_changeset} = Repo.insert(Card.changesetItinerary(%Card{}, new_card))
    end

    if new_card_status == :error do
      {:error, "error: #{inspect new_card_changeset.errors}"}
    else
      existing_cards = Enum.filter(cards, fn(c) -> Map.get(c, "id") != 0 end)

      repo_messages = Enum.map(existing_cards, fn(c) ->
        card_params = Enum.find(cards, fn(cc) -> Map.get(cc, "id") == Map.get(c, "id") end)
        current_card = Repo.get(Card, Map.get(c, "id"))

        if current_card != nil do
          current_card
          |> Card.changesetItinerary(card_params)
          |> Repo.update()
        else
          "Card id: #{Map.get(c, "id")} was not found in database"
        end
      end)

      changesets_errors = Enum.map(repo_messages, fn(c) ->
        case c do
          {:ok, changeset} -> changeset
          {:error, message} -> message
          _ -> c
        end
      end)

      return_package = if new_card_changeset do
        changesets_errors ++ [new_card_changeset]
      else
        changesets_errors
      end

      #sorts the cards
      return_package = Enum.sort(return_package, fn(a, b) ->
        cond do
          is_binary(a) ->
            false
          is_binary(b) ->
            true
          true ->
            a.start_time <= b.start_time
        end
      end)

      {:ok, return_package}
    end
  end
end
