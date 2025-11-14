defmodule EatsWeb.EatLive do
  use EatsWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>Find Foods</.header>
      <form phx-submit="submit">
        <.input name="user_text" type="textarea" value={@user_text} />
        <.button variant="primary">Find Food</.button>
      </form>

      <p>Notes:</p>
      <ul>
        <%= for note <- @notes do %>
          <li>{note}</li>
        <% end %>
      </ul>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{}, _session, socket) do
    socket =
      socket
      |> assign(:page_title, "Find Foods")
      |> assign(:user_text, "")
      |> assign(:food, nil)
      |> assign(:notes, [])

    {:ok, socket}
  end

  @impl true
  def handle_event("submit", %{"user_text" => user_text}, socket) do
    live_pid = self()

    Task.start(fn ->
      Eats.ChatBot.find_food(user_text, live_pid)
    end)

    socket =
      socket
      |> assign(:user_text, user_text)
      |> assign(:notes, [])

    {:noreply, socket}
  end

  @impl true
  def handle_info({:add_note, msg}, socket) do
    socket =
      socket
      |> assign(:notes, [msg | socket.assigns[:notes]])

    {:noreply, socket}
  end
end
