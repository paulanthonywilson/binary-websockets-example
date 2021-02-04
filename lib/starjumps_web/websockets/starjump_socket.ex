defmodule StarjumpsWeb.Websockets.StarjumpSocket do
  @moduledoc """
  `Phoenix.Socket.Transport` implementation for sending star jump images
  to the client connection.
  """

  @behaviour Phoenix.Socket.Transport

  require Logger

  alias Starjumps.Starjumping

  @base_mount_path "/star-jumping"
  @mount_path @base_mount_path <> "/:token"
  @default_frame_switch 1000

  @doc """
  The base path used to mount on the EndPoint, up to the token
  """
  @spec base_mount_path :: String.t()
  def base_mount_path, do: @base_mount_path

  def mount_path, do: @mount_path

  @impl true
  def child_spec(_opts) do
    # Nothing to do here, so noop.
    %{id: Task, start: {Task, :start_link, [fn -> :ok end]}, restart: :transient}
  end

  @impl true
  def connect(_map) do
    {:ok, %{}}
  end

  @impl true
  def init(_) do
    send(self(), :send_image)
    {:ok, %{next_image_in: @default_frame_switch, frame: 0}}
  end

  @impl true
  def handle_in({message, opts}, state) do
    Logger.debug(fn ->
      "#{__MODULE__}.handle_in with message: #{inspect(message)}, opts: #{inspect(opts)}"
    end)

    {:ok, state}
  end

  @impl true
  def handle_info(:send_image, %{frame: frame, next_image_in: send_after} = state) do
    Process.send_after(self(), :send_image, send_after)
    {:push, {:binary, Starjumping.image(frame)}, %{state | frame: frame + 1}}
  end

  def handle_info(_, state) do
    {:ok, state}
  end

  @impl true
  def terminate(reason, _state) do
    Logger.debug(fn -> "#{__MODULE__} terminating because #{inspect(reason)}" end)
    :ok
  end
end
