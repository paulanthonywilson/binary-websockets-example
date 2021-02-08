defmodule StarjumpsWeb.Websockets.StarjumpSocket do
  @moduledoc """
  `Phoenix.Socket.Transport` implementation for sending star jump images
  to the client connection.
  """

  @behaviour Phoenix.Socket.Transport

  require Logger

  alias Starjumps.{Starjumping, JumpRates}

  @base_mount_path "/star-jumping"

  @doc """
  The base path used to mount on the EndPoint, without the token
  """
  @spec base_mount_path :: String.t()
  def base_mount_path, do: @base_mount_path

  @impl true
  def child_spec(_opts) do
    # Nothing to do here, so noop.
    %{id: Task, start: {Task, :start_link, [fn -> :ok end]}, restart: :transient}
  end

  @impl true
  def connect(%{params: %{"token" => token, "jump_rate" => jump_rate}}) do
    {:ok, %{token: token, jump_rate: String.to_integer(jump_rate)}}
  end

  @impl true
  def init(%{token: token, jump_rate: jump_rate}) do
    send(self(), :send_image)
    JumpRates.subscribe(token)
    {:ok, %{next_image_in: jump_rate, jump: 0}}
  end

  @impl true
  def handle_in({message, opts}, state) do
    Logger.debug(fn ->
      "#{__MODULE__} #{inspect(self())} handle_in with message: #{inspect(message)}, opts: #{
        inspect(opts)
      }"
    end)

    {:ok, state}
  end

  @impl true
  def handle_info(:send_image, %{jump: jump, next_image_in: send_after} = state) do
    Process.send_after(self(), :send_image, send_after)
    {:push, {:binary, Starjumping.image(jump)}, %{state | jump: jump + 1}}
  end

  def handle_info({:jump_rate_change, new_next_image_in}, %{jump: jump} = state) do
    {:push, {:binary, Starjumping.image(jump - 1)}, %{state | next_image_in: new_next_image_in}}
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
