defmodule StarjumpsWeb.Websockets.StarjumpSocketTest do
  use ExUnit.Case, async: true

  alias Starjumps.Starjumping
  alias StarjumpsWeb.Websockets.StarjumpSocket

  describe "sending images via timed message" do
    test "sends the frame's image on  receiving a :send_image message" do
      assert {:push, {:binary, image}, %{frame: 1} = next_state} =
               StarjumpSocket.handle_info(:send_image, %{next_image_in: 1, frame: 0})

      assert image == Starjumping.image(0)

      next_image = Starjumping.image(1)
      assert {:push, {_, ^next_image}, _} = StarjumpSocket.handle_info(:send_image, next_state)
    end

    test "schedules the next image to be sent" do
      StarjumpSocket.handle_info(:send_image, %{next_image_in: 80, frame: 1})

      # Scheduled for about 80ms, so not sent yet
      refute_received :send_image

      assert_receive :send_image
    end
  end

  describe "init" do
    test "sets initial state" do
      assert {:ok, %{next_image_in: 1_000, frame: 0}} == StarjumpSocket.init(%{})
    end

    test "gets the first image sent" do
      StarjumpSocket.init(%{})
      assert_received :send_image
    end
  end
end
