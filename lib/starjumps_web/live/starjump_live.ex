defmodule StarjumpsWeb.StarjumpLive do
  @moduledoc """
  The main page. Displays a star jumping stick figure.
  """
  use StarjumpsWeb, :live_view

  import StarjumpsWeb.Websockets.StarjumpHelper,
    only: [
      star_jump_image_ws_url: 3,
      jump_rate_options: 0,
      default_jump_rate: 0,
      change_jump_rate: 2
    ]

  def mount(_params, _session, socket) do
    {:ok, assign(socket, token: UUID.uuid4(), jump_rate: default_jump_rate())}
  end

  def render(assigns) do
    ~L"""
    <div class="row">
      <div class="column">
        <%= img_tag(Routes.static_path(@socket,  "/images/placeholder.jpg"),
              data_binary_ws_url: star_jump_image_ws_url(@token, @jump_rate, @socket),
              phx_hook: "ImageHook",
              id: "star-jump-img") %>
       </div>
      <div class="column">
          <form phx-change="change-jump-rate" class="change-jump-rate">
            <label for="jump-rate">Jump rate</label>
            <select name="jump-rate">
              <%=  options_for_select jump_rate_options(), @jump_rate %>
            </select>
          </form>
      </div>
    </div>
    """
  end

  def handle_event(
        "change-jump-rate",
        %{"jump-rate" => jump_rate},
        %{assigns: %{token: token}} = socket
      ) do
    jump_rate = String.to_integer(jump_rate)
    change_jump_rate(token, jump_rate)
    {:noreply, assign(socket, jump_rate: jump_rate)}
  end
end
