# RubyslavaElixir

Basic application with simple LiveView implementations:
- message board
- random quotes generator

Slides from presentation: https://www.slideshare.net/quatermain1/rubyslava-phoenix-liveview

## Running

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Deploy

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html) or just deploy it with fly.io:
1. Install cli
   ```
   brew install superfly/tap/flyctl
   ```
   more: https://fly.io/docs/getting-started/installing-flyctl/
2. Login or sign up
   ```
   flyctl auth login
   # or
   flyctl auth signup
   ```
3. Create & Deploy app
   ```
   fly launch
   ```

## Message board

Simple list of messages stored in memory with [Agent](https://hexdocs.pm/elixir/1.13/Agent.html) implementation. This messages list is loaded and updated by every running LiveView instances. Agent implementation is just simulation of some kind of storage for these messages. It's not recommended to use in real use cases.
Every new message is broadcasted with [Phoenix PubSub](https://hexdocs.pm/phoenix_pubsub/Phoenix.PubSub.html) to other running LiveView processes. This implementation is example how can be optimized storage management for better performance. Filtering new questions is not optimized and I can say using `Enum.uniq_by/2` is wrong, but it works for this example.

## Random quotes generator

List of quotes is downloaded from publicly available [Gist](https://gist.githubusercontent.com/JakubPetriska/060958fd744ca34f099e947cd080b540/raw/963b5a9355f04741239407320ac973a6096cd7b6/quotes.csv) in [GenServer](https://hexdocs.pm/elixir/1.13/GenServer.html) implementation. After the list is loaded it will take one random quote and broadcast it to channel. Broadcasting is implemented with [Phoenix PubSub](https://hexdocs.pm/phoenix_pubsub/Phoenix.PubSub.html) and it will delivery messages(quotes) to every process which is subscribed to specific channel. Simple LiveView implementation is subscribed to this channel and automatically show every quotes in UI immediately when is broadcasted.


## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
