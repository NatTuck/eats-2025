defmodule EatsWeb.SnackLive.Index do
  use EatsWeb, :live_view

  alias Eats.Snacks

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Listing Snacks
        <:actions>
          <.button variant="primary" navigate={~p"/snacks/new"}>
            <.icon name="hero-plus" /> New Snack
          </.button>
        </:actions>
      </.header>

      <.table
        id="snacks"
        rows={@streams.snacks}
        row_click={fn {_id, snack} -> JS.navigate(~p"/snacks/#{snack}") end}
      >
        <:col :let={{_id, snack}} label="Fdc">{snack.fdc_id}</:col>
        <:col :let={{_id, snack}} label="Desc">{snack.desc}</:col>
        <:col :let={{_id, snack}} label="Grams">{snack.grams}</:col>
        <:action :let={{_id, snack}}>
          <div class="sr-only">
            <.link navigate={~p"/snacks/#{snack}"}>Show</.link>
          </div>
          <.link navigate={~p"/snacks/#{snack}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, snack}}>
          <.link
            phx-click={JS.push("delete", value: %{id: snack.id}) |> hide("##{id}")}
            data-confirm="Are you sure?"
          >
            Delete
          </.link>
        </:action>
      </.table>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Listing Snacks")
     |> stream(:snacks, list_snacks())}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    snack = Snacks.get_snack!(id)
    {:ok, _} = Snacks.delete_snack(snack)

    {:noreply, stream_delete(socket, :snacks, snack)}
  end

  defp list_snacks() do
    Snacks.list_snacks()
  end
end
