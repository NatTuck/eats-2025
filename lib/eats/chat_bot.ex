defmodule Eats.ChatBot do
  alias LangChain.Function
  alias LangChain.FunctionParam
  alias LangChain.Chains.LLMChain
  alias LangChain.Message

  alias Eats.ChatLocal
  alias Eats.Foods

  def find_food(text, pid) do
    IO.inspect({ChatBot, :find_food, text})

    {:ok, model} = ChatLocal.new()

    {:ok, chain} =
      LLMChain.new!(%{llm: model, custom_context: %{pid: pid}})
      |> LLMChain.add_tools(tools())
      |> LLMChain.add_messages(prompt(text))
      |> LLMChain.run(mode: :while_needs_response)

    IO.inspect(chain.last_message, pretty: true)
  end

  def tools() do
    [
      Function.new!(%{
        name: "search_foods",
        description: "Search USDA food descriptions",
        parameters: [
          FunctionParam.new!(%{name: "text", type: :string, required: true})
        ],
        function: fn %{"text" => text}, %{pid: pid} ->
          send(pid, {:add_note, "top_matches(#{text})"})
          IO.inspect({:top_matches, text})
          {:ok, Jason.encode!(Foods.top_matches(text))}
        end
      }),
      Function.new!(%{
        name: "get_food",
        description: "Get food by fdc_id",
        parameters: [
          FunctionParam.new!(%{name: "id", type: :integer, required: true})
        ],
        function: fn %{"id" => id}, %{pid: pid} ->
          send(pid, {:get_food, "#{id}"})
          IO.inspect({:get_food, id})

          case Foods.get_food(id) do
            {:ok, food} -> {:ok, Jason.encode!(food)}
            :error -> {:error, "not found"}
          end
        end
      })
    ]
  end

  def prompt(text) do
    [
      Message.new_system!("""
      You are a food and nutrition tracking assistant.

      Given a food description, your goal is to figure out what kind of
      food it is and in what quantity, and then to determine its nutrient
      contents.
      """),
      Message.new_user!("""
      Here's the food description:

      <description>
      #{text}
      </description>

      Follow this process:

      - Determine what words describe the type of food.
      - Determine what quantity of food is described.
      - Search the USDA food descriptions for a matching food using
        the search_foods tool.

      Respond with the search result that is the best match to the
      provided description.
      """)
    ]
  end
end
