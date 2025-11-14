defmodule EatsWeb.SnackLive.Form do
  use EatsWeb, :live_view

  alias Eats.Snacks
  alias Eats.Snacks.Snack

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage snack records in your database.</:subtitle>
      </.header>

      <.form for={@form} id="snack-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:fdc_id]} type="number" label="Fdc" />
        <.input field={@form[:desc]} type="text" label="Desc" />
        <.input field={@form[:grams]} type="number" label="Grams" />
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save Snack</.button>
          <.button navigate={return_path(@return_to, @snack)}>Cancel</.button>
        </footer>
      </.form>
    </Layouts.app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  defp apply_action(socket, :edit, %{"id" => id}) do
    snack = Snacks.get_snack!(id)

    socket
    |> assign(:page_title, "Edit Snack")
    |> assign(:snack, snack)
    |> assign(:form, to_form(Snacks.change_snack(snack)))
  end

  defp apply_action(socket, :new, _params) do
    snack = %Snack{}

    socket
    |> assign(:page_title, "New Snack")
    |> assign(:snack, snack)
    |> assign(:form, to_form(Snacks.change_snack(snack)))
  end

  @impl true
  def handle_event("validate", %{"snack" => snack_params}, socket) do
    changeset = Snacks.change_snack(socket.assigns.snack, snack_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"snack" => snack_params}, socket) do
    save_snack(socket, socket.assigns.live_action, snack_params)
  end

  defp save_snack(socket, :edit, snack_params) do
    case Snacks.update_snack(socket.assigns.snack, snack_params) do
      {:ok, snack} ->
        {:noreply,
         socket
         |> put_flash(:info, "Snack updated successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, snack))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_snack(socket, :new, snack_params) do
    case Snacks.create_snack(snack_params) do
      {:ok, snack} ->
        {:noreply,
         socket
         |> put_flash(:info, "Snack created successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, snack))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path("index", _snack), do: ~p"/snacks"
  defp return_path("show", snack), do: ~p"/snacks/#{snack}"
end
