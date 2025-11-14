defmodule Eats.Snacks.Snack do
  use Ecto.Schema
  import Ecto.Changeset

  schema "snacks" do
    field :fdc_id, :integer
    field :desc, :string
    field :grams, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(snack, attrs) do
    snack
    |> cast(attrs, [:fdc_id, :desc, :grams])
    |> validate_required([:fdc_id, :desc, :grams])
  end
end
