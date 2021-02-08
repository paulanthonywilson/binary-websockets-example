defmodule StarjumpsWeb.Websockets.StarjumpHelper do
  @moduledoc """
  Greases the wheels of the start jump animation
  """

  alias Starjumps.JumpRates
  alias StarjumpsWeb.Websockets.StarjumpSocket

  @jump_rate_options [
    {"100ms", 100},
    {"1/4 sec", 250},
    {"1/2 sec", 500},
    {"1 sec", 1_000},
    {"2 secs", 2_000},
    {"5 secs", 5_000}
  ]

  def star_jump_image_ws_url(token, jump_rate, %{host_uri: host_uri}) do
    host_uri
    |> base_url()
    |> Path.join(StarjumpSocket.base_mount_path())
    |> Path.join(token)
    |> Path.join(to_string(jump_rate))
    |> Path.join("websocket")
  end

  def jump_rate_options, do: @jump_rate_options
  defdelegate default_jump_rate, to: JumpRates

  defdelegate change_jump_rate(token, new_rate), to: JumpRates

  defp base_url(%{scheme: http_scheme, host: host, port: port}) do
    "#{ws_scheme(http_scheme)}://#{host}#{port_part(http_scheme, port)}"
  end

  defp ws_scheme("http"), do: "ws"
  defp ws_scheme("https"), do: "wss"

  defp port_part("http", 80), do: ""
  defp port_part("https", 443), do: ""
  defp port_part(_, port), do: ":#{port}"
end
