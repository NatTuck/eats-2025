defmodule Eats.Foods do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def top_matches(text) do
    GenServer.call(__MODULE__, {:top_matches, text})
  end

  def get_food(fdc_id) do
    GenServer.call(__MODULE__, {:get_food, fdc_id})
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
        desc = Map.get(food, "description")
        score = FuzzyCompare.similarity(desc, text)
        %{score: score, id: id, desc: desc}
      end
      |> Enum.sort_by(& &1.score, :desc)
      |> Enum.take(10)

    {:reply, matches, foods}
  end

  def handle_call({:get_food, fdc_id}, _from, foods) do
    {:reply, Map.fetch(foods, fdc_id), foods}
  end
end
