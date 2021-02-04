defmodule Starjumps.StarjumpingTest do
  use ExUnit.Case, async: true

  alias Starjumps.Starjumping

  describe "star_jump_image" do
    test "images are jpegs" do
      assert <<0xFF, 0xD8, 0xFF>> <> _ = Starjumping.image(0)
      assert <<0xFF, 0xD8, 0xFF>> <> _ = Starjumping.image(1)
    end

    test "images returned alternate depending on the index" do
      assert Starjumping.image(0) != Starjumping.image(1)
      assert Starjumping.image(0) == Starjumping.image(2)
      assert Starjumping.image(0) != Starjumping.image(3)
      assert Starjumping.image(0) == Starjumping.image(4)
      assert Starjumping.image(0) != Starjumping.image(-1)
      assert Starjumping.image(0) == Starjumping.image(-2)
    end
  end
end
