defmodule Eats.Repo.Migrations.CreateSnacks do
  use Ecto.Migration

  def change do
    create table(:snacks) do
      add :fdc_id, :integer, null: false
      add :desc, :string, null: false
      add :grams, :integer, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
