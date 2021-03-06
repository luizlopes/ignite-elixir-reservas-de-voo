defmodule Flightex.Bookings.CreateOrUpdateTest do
  use ExUnit.Case, async: false

  import Flightex.Factory

  alias Flightex.Bookings.{Agent, CreateOrUpdate}

  describe "call/1" do
    setup do
      Flightex.start_agents()

      :ok
    end

    test "when all params are valid, returns a valid tuple" do
      user_params = %{
        name: "Jp",
        email: "jp@banana.com",
        cpf: "12345678900"
      }

      {:ok, user_uuid} = Flightex.Users.CreateOrUpdate.call(user_params)

      params = build(:booking_params, user_id: user_uuid)

      {:ok, uuid} = CreateOrUpdate.call(params)

      {:ok, response} = Agent.get(uuid)

      expected_response = %Flightex.Bookings.Booking{
        id: response.id,
        complete_date: ~N[2001-05-07 12:00:00],
        local_destination: "Bananeiras",
        local_origin: "Brasilia",
        user_id: user_uuid
      }

      assert response == expected_response
    end

    test "when user is invalid, returns an error" do
      params = build(:booking_params)

      assert CreateOrUpdate.call(params) == {:error, "User not found"}
    end
  end
end
