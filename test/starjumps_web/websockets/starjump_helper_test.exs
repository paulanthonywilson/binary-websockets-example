defmodule StarjumpsWeb.Websockets.StarjumpHelperTest do
  use ExUnit.Case, async: true

  alias Phoenix.LiveView.Socket
  alias StarjumpsWeb.Websockets.StarjumpHelper

  describe "star jump image websocket url" do
    test "http scheme translates to ws " do
      assert StarjumpHelper.star_jump_image_ws_url("abc-123", 500, %Socket{
               host_uri: %URI{scheme: "http", host: "mycomputer.local", port: 4040}
             }) == "ws://mycomputer.local:4040/star-jumping/abc-123/500/websocket"
    end

    test "https scheme translates to wss" do
      assert StarjumpHelper.star_jump_image_ws_url("abc-123", 250, %Socket{
               host_uri: %URI{scheme: "https", host: "mycomputer.local", port: 4040}
             }) == "wss://mycomputer.local:4040/star-jumping/abc-123/250/websocket"
    end

    test "port 80 on http is ommitted" do
      assert StarjumpHelper.star_jump_image_ws_url("abc-123", 500, %Socket{
               host_uri: %URI{scheme: "http", host: "mycomputer.local", port: 80}
             }) == "ws://mycomputer.local/star-jumping/abc-123/500/websocket"
    end

    test "port 443 on https is ommitted" do
      assert StarjumpHelper.star_jump_image_ws_url("abc-123", 500, %Socket{
               host_uri: %URI{scheme: "https", host: "mycomputer.local", port: 443}
             }) == "wss://mycomputer.local/star-jumping/abc-123/500/websocket"
    end
  end
end
