defmodule WeatherApp.DataTest do
  use WeatherApp.DataCase

  alias WeatherApp.Data

  describe "infos" do
    alias WeatherApp.Data.Info

    @valid_attrs %{date_time: "some date_time", weather_data: %{}}
    @update_attrs %{date_time: "some updated date_time", weather_data: %{}}
    @invalid_attrs %{date_time: nil, weather_data: nil}

    def info_fixture(attrs \\ %{}) do
      {:ok, info} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Data.create_info()

      info
    end

    test "list_infos/0 returns all infos" do
      info = info_fixture()
      assert Data.list_infos() == [info]
    end

    test "get_info!/1 returns the info with given id" do
      info = info_fixture()
      assert Data.get_info!(info.id) == info
    end

    test "create_info/1 with valid data creates a info" do
      assert {:ok, %Info{} = info} = Data.create_info(@valid_attrs)
      assert info.date_time == "some date_time"
      assert info.weather_data == %{}
    end

    test "create_info/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Data.create_info(@invalid_attrs)
    end

    test "update_info/2 with valid data updates the info" do
      info = info_fixture()
      assert {:ok, %Info{} = info} = Data.update_info(info, @update_attrs)
      assert info.date_time == "some updated date_time"
      assert info.weather_data == %{}
    end

    test "update_info/2 with invalid data returns error changeset" do
      info = info_fixture()
      assert {:error, %Ecto.Changeset{}} = Data.update_info(info, @invalid_attrs)
      assert info == Data.get_info!(info.id)
    end

    test "delete_info/1 deletes the info" do
      info = info_fixture()
      assert {:ok, %Info{}} = Data.delete_info(info)
      assert_raise Ecto.NoResultsError, fn -> Data.get_info!(info.id) end
    end

    test "change_info/1 returns a info changeset" do
      info = info_fixture()
      assert %Ecto.Changeset{} = Data.change_info(info)
    end
  end
end
