defmodule StarjumpsWeb.Websockets.StarjumpHelper do
  @moduledoc """
  Greases the wheels of the start jump animation
  """

  alias StarjumpsWeb.Websockets.StarjumpSocket

  def star_jump_image_ws_url(token, %{host_uri: host_uri}) do
    host_uri
    |> base_url()
    |> Path.join(StarjumpSocket.base_mount_path())
    |> Path.join(token)
    |> Path.join("websocket")
  end

  defp base_url(%{scheme: http_scheme, host: host, port: port}) do
    "#{ws_scheme(http_scheme)}://#{host}#{port_part(http_scheme, port)}"
  end

  defp ws_scheme("http"), do: "ws"
  defp ws_scheme("https"), do: "wss"

  defp port_part("http", 80), do: ""
  defp port_part("https", 443), do: ""
  defp port_part(_, port), do: ":#{port}"
end
