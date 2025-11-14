defmodule EatsWeb.SnackLiveTest do
  use EatsWeb.ConnCase

  import Phoenix.LiveViewTest
  import Eats.SnacksFixtures

  @create_attrs %{desc: "some desc", fdc_id: 42, grams: 42}
  @update_attrs %{desc: "some updated desc", fdc_id: 43, grams: 43}
  @invalid_attrs %{desc: nil, fdc_id: nil, grams: nil}
  defp create_snack(_) do
    snack = snack_fixture()

    %{snack: snack}
  end

  describe "Index" do
    setup [:create_snack]

    test "lists all snacks", %{conn: conn, snack: snack} do
      {:ok, _index_live, html} = live(conn, ~p"/snacks")

      assert html =~ "Listing Snacks"
      assert html =~ snack.desc
    end

    test "saves new snack", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/snacks")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Snack")
               |> render_click()
               |> follow_redirect(conn, ~p"/snacks/new")

      assert render(form_live) =~ "New Snack"

      assert form_live
             |> form("#snack-form", snack: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#snack-form", snack: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/snacks")

      html = render(index_live)
      assert html =~ "Snack created successfully"
      assert html =~ "some desc"
    end

    test "updates snack in listing", %{conn: conn, snack: snack} do
      {:ok, index_live, _html} = live(conn, ~p"/snacks")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#snacks-#{snack.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/snacks/#{snack}/edit")

      assert render(form_live) =~ "Edit Snack"

      assert form_live
             |> form("#snack-form", snack: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#snack-form", snack: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/snacks")

      html = render(index_live)
      assert html =~ "Snack updated successfully"
      assert html =~ "some updated desc"
    end

    test "deletes snack in listing", %{conn: conn, snack: snack} do
      {:ok, index_live, _html} = live(conn, ~p"/snacks")

      assert index_live |> element("#snacks-#{snack.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#snacks-#{snack.id}")
    end
  end

  describe "Show" do
    setup [:create_snack]

    test "displays snack", %{conn: conn, snack: snack} do
      {:ok, _show_live, html} = live(conn, ~p"/snacks/#{snack}")

      assert html =~ "Show Snack"
      assert html =~ snack.desc
    end

    test "updates snack and returns to show", %{conn: conn, snack: snack} do
      {:ok, show_live, _html} = live(conn, ~p"/snacks/#{snack}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/snacks/#{snack}/edit?return_to=show")

      assert render(form_live) =~ "Edit Snack"

      assert form_live
             |> form("#snack-form", snack: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#snack-form", snack: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/snacks/#{snack}")

      html = render(show_live)
      assert html =~ "Snack updated successfully"
      assert html =~ "some updated desc"
    end
  end
end
