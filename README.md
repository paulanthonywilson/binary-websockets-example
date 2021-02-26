# Starjumps

Example Phoenix application illustrating using a custom [`Phoenix.Socket.Transport](https://hexdocs.pm/phoenix/1.5.7/Phoenix.Socket.Transport.html) implementation to send binary messages over a websocket. It alternates two images to show a stick figure doing star jumps.

For a detailed description see the tutorial post, which is [here](https://furlough.merecomplexities.com/elixir/phoenix/tutorial/2021/02/19/binary-websockets-with-elixir-phoenix.html).

A [Content Security Policy](https://content-security-policy.com) has been added for the purposes of [this post](https://furlough.merecomplexities.com/elixir/phoenix/security/2021/02/26/content-security-policy-configuration-in-phoenix.html).

# Installation and running

This is a standard Phoenix install so mmake sure you have [Elixir](https://elixir-lang.org/install.html) and [Node](https://nodejs.dev/learn/how-to-install-nodejs) installed.

```bash
git clone git@github.com:paulanthonywilson/binary-websockets-example.git
cd binary-websockets-example
mix deps.get
cd assets
npm install
cd ..
iex -S mix phx.server
```

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.


