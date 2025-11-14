defmodule Eats.SnacksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Eats.Snacks` context.
  """

  @doc """
  Generate a snack.
  """
  def snack_fixture(attrs \\ %{}) do
    {:ok, snack} =
      attrs
      |> Enum.into(%{
        desc: "some desc",
        fdc_id: 42,
        grams: 42
      })
      |> Eats.Snacks.create_snack()

    snack
  end
end
