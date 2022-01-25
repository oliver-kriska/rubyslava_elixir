NimbleCSV.define(RubyslavaElixir.Quotes.Parser, separator: ";", escape: "\"")

defmodule RubyslavaElixir.Quotes do
  @moduledoc """
  GenServer implementation for loading and broadcasting quotes
  """

  use GenServer

  alias Phoenix.PubSub
  alias RubyslavaElixir.Quote
  alias RubyslavaElixir.Quotes.Parser

  @quotes_source_url "https://raw.githubusercontent.com/akhiltak/inspirational-quotes/master/Quotes.csv"
  @pub_sub_server RubyslavaElixir.PubSub

  @impl true
  def init(_) do
    {:ok, [], {:continue, :load_quotes}}
  end

  def start_link(quotes) do
    GenServer.start_link(__MODULE__, quotes)
  end

  @impl true
  def handle_continue(:load_quotes, quotes) do
    quotes =
      Finch.build(:get, @quotes_source_url)
      |> Finch.request(RubyslavaElixir.Finch)
      |> case do
        {:ok, %{body: body}} ->
          parse_body(body)

        _ ->
          quotes
      end

    schedule_broadcast(1)
    {:noreply, quotes}
  end

  @impl true
  def handle_info(:broadcast, []), do: {:noreply, [], {:continue, :load_quotes}}

  def handle_info(:broadcast, quotes) do
    rand = :rand.uniform(length(quotes))
    {new_quote, quotes} = List.pop_at(quotes, rand)
    PubSub.broadcast!(@pub_sub_server, "quotes", {:new_quote, new_quote})
    schedule_broadcast()
    {:noreply, quotes}
  end

  defp schedule_broadcast(delay \\ :timer.seconds(30)),
    do: Process.send_after(self(), :broadcast, delay)

  defp parse_body(body) do
    body
    |> Parser.parse_string()
    |> Enum.map(fn [quote_string, author, _genre] ->
      %Quote{quote: :binary.copy(quote_string), author: :binary.copy(author)}
    end)
  end
end
