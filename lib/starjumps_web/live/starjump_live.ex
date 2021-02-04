defmodule StarjumpsWeb.StarjumpLive do
  @moduledoc """
  The main page. Displays a star jumping stick figure.
  """
  use StarjumpsWeb, :live_view

  import StarjumpsWeb.Websockets.StarjumpHelper, only: [star_jump_image_ws_url: 2]

  def mount(_params, _session, socket) do
    {:ok, assign(socket, token: UUID.uuid4())}
  end

  def render(assigns) do
    ~L"""
    <div class="row">
      <div class="column">
        <%= img_tag(Routes.static_path(@socket,  "/images/placeholder.jpg"),
              data_binary_ws_url: star_jump_image_ws_url(@token, @socket),
              phx_hook: "ImageHook",
              id: "star-jump-img") %>
       </div>
      <div class="column">
        Yo
      </div>
    </div>
    """
  end
end
