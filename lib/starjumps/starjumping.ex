defmodule Starjumps.Starjumping do
  @moduledoc """
  Holds and servers out the images of our little star jumper
  """

  image_dir = Application.app_dir(:starjumps, "priv/jumper_images")

  @image_0 image_dir |> Path.join("stick_1.jpg") |> File.read!()
  @image_1 image_dir |> Path.join("stick_2.jpg") |> File.read!()

  @doc """
  Alternate which image to return depending on the index
  """
  @spec image(integer()) :: binary()
  def image(0), do: @image_0
  def image(1), do: @image_1

  def image(i), do: i |> Integer.mod(2) |> image()
end
