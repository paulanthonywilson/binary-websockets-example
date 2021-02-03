# Starjumps

Example Phoenix application illustrating using a custom [`Phoenix.Socket.Transport](https://hexdocs.pm/phoenix/1.5.7/Phoenix.Socket.Transport.html) implementation to send binary messages over a websocket. It alternates two images to show a stick figure doing star jumps.

For a detailed description see the tutorial post, which is not posted at the time of writing this README.

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


