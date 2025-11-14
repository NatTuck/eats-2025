defmodule Eats.SnacksTest do
  use Eats.DataCase

  alias Eats.Snacks

  describe "snacks" do
    alias Eats.Snacks.Snack

    import Eats.SnacksFixtures

    @invalid_attrs %{desc: nil, fdc_id: nil, grams: nil}

    test "list_snacks/0 returns all snacks" do
      snack = snack_fixture()
      assert Snacks.list_snacks() == [snack]
    end

    test "get_snack!/1 returns the snack with given id" do
      snack = snack_fixture()
      assert Snacks.get_snack!(snack.id) == snack
    end

    test "create_snack/1 with valid data creates a snack" do
      valid_attrs = %{desc: "some desc", fdc_id: 42, grams: 42}

      assert {:ok, %Snack{} = snack} = Snacks.create_snack(valid_attrs)
      assert snack.desc == "some desc"
      assert snack.fdc_id == 42
      assert snack.grams == 42
    end

    test "create_snack/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Snacks.create_snack(@invalid_attrs)
    end

    test "update_snack/2 with valid data updates the snack" do
      snack = snack_fixture()
      update_attrs = %{desc: "some updated desc", fdc_id: 43, grams: 43}

      assert {:ok, %Snack{} = snack} = Snacks.update_snack(snack, update_attrs)
      assert snack.desc == "some updated desc"
      assert snack.fdc_id == 43
      assert snack.grams == 43
    end

    test "update_snack/2 with invalid data returns error changeset" do
      snack = snack_fixture()
      assert {:error, %Ecto.Changeset{}} = Snacks.update_snack(snack, @invalid_attrs)
      assert snack == Snacks.get_snack!(snack.id)
    end

    test "delete_snack/1 deletes the snack" do
      snack = snack_fixture()
      assert {:ok, %Snack{}} = Snacks.delete_snack(snack)
      assert_raise Ecto.NoResultsError, fn -> Snacks.get_snack!(snack.id) end
    end

    test "change_snack/1 returns a snack changeset" do
      snack = snack_fixture()
      assert %Ecto.Changeset{} = Snacks.change_snack(snack)
    end
  end
end
