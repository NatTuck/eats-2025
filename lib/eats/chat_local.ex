defmodule Eats.ChatLocal do
  alias LangChain.ChatModels.ChatOpenAI

  def new do
    ChatOpenAI.new(%{
      endpoint: "http://localhost:8080/v1/chat/completions",
      api_key: "none",
      cache_prompt: true
    })
  end
end
