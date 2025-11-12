defmodule Eats.Repo do
  use Ecto.Repo,
    otp_app: :eats,
    adapter: Ecto.Adapters.SQLite3
end
