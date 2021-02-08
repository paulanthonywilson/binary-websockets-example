defmodule StarjumpsWeb.Websockets.StarjumpSocketTest do
  use ExUnit.Case, async: true

  alias Starjumps.{Starjumping, JumpRates}
  alias StarjumpsWeb.Websockets.StarjumpSocket

  describe "sending images via timed message" do
    test "sends the frame's image on  receiving a :send_image message" do
      assert {:push, {:binary, image}, %{jump: 1} = next_state} =
               StarjumpSocket.handle_info(:send_image, %{next_image_in: 1, jump: 0})

      assert image == Starjumping.image(0)

      next_image = Starjumping.image(1)
      assert {:push, {_, ^next_image}, _} = StarjumpSocket.handle_info(:send_image, next_state)
    end

    test "schedules the next image to be sent" do
      StarjumpSocket.handle_info(:send_image, %{next_image_in: 80, jump: 1})

      # Scheduled for about 80ms, so not sent yet
      refute_received :send_image

      assert_receive :send_image
    end
  end

  describe "init" do
    test "sets initial state" do
      assert {:ok, %{next_image_in: 250, jump: 0}} ==
               StarjumpSocket.init(%{token: "123", jump_rate: 250})
    end

    test "gets the first image sent" do
      StarjumpSocket.init(%{token: "", jump_rate: 100})
      assert_received :send_image
    end
  end

  describe "jump rates" do
    test "jump rate and token passed to init, by connect" do
      assert {:ok, %{token: "i-am-teh-tokehn", jump_rate: 250}} =
               StarjumpSocket.connect(%{
                 params: %{"token" => "i-am-teh-tokehn", "jump_rate" => "250"}
               })
    end

    test "init subscribes to jump rate updates for its token" do
      StarjumpSocket.init(%{token: "tokenz", jump_rate: 200})
      JumpRates.change_jump_rate("tokenz", 200)
      assert_receive {:jump_rate_change, 200}
    end

    test "changes the jump rate (next_image_in) on receipt of a :jump_rate_change message" do
      assert {:ok, %{next_image_in: 123}} =
               StarjumpSocket.handle_info({:jump_rate_change, 123}, %{next_image_in: 1, jump: 0})
    end
  end
end
