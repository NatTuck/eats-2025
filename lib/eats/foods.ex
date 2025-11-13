defmodule Eats.Foods do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def top_matches(text) do
    GenServer.call(__MODULE__, {:top_matches, text})
  end

  @impl true
  def init(_) do
    IO.puts("Loading foods...")
    foods = load_foods()
    IO.puts("  done loading foods.")
    {:ok, foods}
  end

  def load_foods() do
    data_dir = Application.app_dir(:eats, "priv/data")

    name =
      data_dir
      |> File.ls!()
      |> Enum.filter(&String.match?(&1, ~r/.zst$/))
      |> Enum.take(1)

    data_dir
    |> Path.join(name)
    |> File.read!()
    |> ExZstd.decompress!()
    |> Jason.decode!()
    |> Map.get("SurveyFoods")
    |> foods_by_fdc_id()
  end

  def foods_by_fdc_id(foods) do
    for food <- foods do
      {Map.get(food, "fdcId"), food}
    end
    |> Enum.into(%{})
  end

  @impl true
  def handle_call({:top_matches, text}, _from, foods) do
    matches =
      for {id, food} <- foods do
        descr = Map.get(food, "description")
        score = FuzzyCompare.similarity(descr, text)
        %{score: score, id: id, food: food}
      end
      |> Enum.sort_by(& &1.score, :desc)
      |> Enum.take(5)

    {:reply, matches, foods}
  end
end
