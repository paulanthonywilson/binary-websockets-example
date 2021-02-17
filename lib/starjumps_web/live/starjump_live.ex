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

  @impl true
  def mount(_params, _session, socket) do
    token = UUID.uuid4()
    jump_rate = default_jump_rate()
    image_ws_url = star_jump_image_ws_url(token, jump_rate, socket)
    {:ok, assign(socket, token: token, jump_rate: jump_rate, image_ws_url: image_ws_url)}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <div class="row">
      <div class="column">
       <img data-binary-ws-url="<%= @image_ws_url %>"
            id="star-jump-img"
            phx-hook="ImageHook"
            src="/images/placeholder.jpg">
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

  @impl true
  def handle_event(
        "change-jump-rate",
        %{"jump-rate" => jump_rate},
        %{assigns: %{token: token}} = socket
      ) do
    jump_rate = String.to_integer(jump_rate)
    change_jump_rate(token, jump_rate)

    {:noreply,
     assign(socket,
       jump_rate: jump_rate,
       image_ws_url: star_jump_image_ws_url(token, jump_rate, socket)
     )}
  end
end
