defmodule Starjumps.JumpRatestest do
  use ExUnit.Case, async: true

  alias Starjumps.JumpRates

  test "receives notifications for subscribed token" do
    JumpRates.subscribe("123")
    JumpRates.change_jump_rate("123", 400)

    assert_received {:jump_rate_change, 400}
  end

  test "jump rates notifications for other tokens are not received" do
    JumpRates.subscribe("123")
    JumpRates.change_jump_rate("456", 400)

    refute_received {:jump_rate_change, _}
  end
end
