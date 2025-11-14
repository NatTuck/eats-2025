defmodule EatsWeb.SnackLive.Show do
  use EatsWeb, :live_view

  alias Eats.Snacks

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Snack {@snack.id}
        <:subtitle>This is a snack record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/snacks"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/snacks/#{@snack}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit snack
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Fdc">{@snack.fdc_id}</:item>
        <:item title="Desc">{@snack.desc}</:item>
        <:item title="Grams">{@snack.grams}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Snack")
     |> assign(:snack, Snacks.get_snack!(id))}
  end
end
