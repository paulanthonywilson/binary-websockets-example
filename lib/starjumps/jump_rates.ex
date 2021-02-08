defmodule Starjumps.JumpRates do
  @moduledoc """
  Handles setting jump rates, and subscribing to receive notifications of changing the jump rate
  """

  alias Phoenix.PubSub

  @default_jump_rate 1000

  def default_jump_rate, do: @default_jump_rate

  @doc """
  Get notifications on jump rate changes for the supplied jumping token
  """
  @spec subscribe(String.t()) :: :ok | {:error, {:already_registered, pid}}
  def subscribe(token) do
    PubSub.subscribe(pub_sub_server(), topic(token))
  end

  @doc """
  Notifies subscribers that the jump rate has changed for the supplied jumping token.
  Does no other work, assuming that a subscriber will change the jump rate.
  """
  @spec change_jump_rate(String.t(), pos_integer()) :: :ok
  def change_jump_rate(token, new_rate) do
    PubSub.broadcast!(pub_sub_server(), topic(token), {:jump_rate_change, new_rate})
  end

  defp pub_sub_server,
    do:
      :starjumps
      |> Application.fetch_env!(StarjumpsWeb.Endpoint)
      |> Keyword.fetch!(:pubsub_server)

  defp topic(token), do: "#{__MODULE__}:#{token}"
end
