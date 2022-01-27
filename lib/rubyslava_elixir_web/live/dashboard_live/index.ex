defmodule RubyslavaElixirWeb.DashboardLive.Index do
  @moduledoc """
  Simple LiveView implementation
  """
  use RubyslavaElixirWeb, :live_view

  alias Phoenix.PubSub
  alias RubyslavaElixir.Questions
  alias RubyslavaElixirWeb.BoardPresence

  @pub_sub_server RubyslavaElixir.PubSub
  @topic "questions"

  @impl true
  def mount(_params, _session, socket) do
    name = Questions.random_name()

    if connected?(socket) do
      Process.send_after(self(), :get_questions, 1)
      Phoenix.PubSub.subscribe(@pub_sub_server, @topic)
      Phoenix.PubSub.subscribe(@pub_sub_server, "quotes")

      BoardPresence.track(self(), @topic, name, %{
        online_at: inspect(System.system_time(:second))
      })
    end

    socket =
      socket
      |> assign(:questions, [])
      |> assign(:quote, nil)
      |> assign(:name, name)
      |> update_online_users()

    {:ok, socket}
  end

  @impl true
  def handle_event(
        "ask",
        %{"question" => body},
        %{assigns: %{questions: questions, name: name}} = socket
      ) do
    question = create_question(body, name)
    {:noreply, assign(socket, questions: questions ++ [question])}
  end

  def handle_event(_event, _, socket), do: {:noreply, socket}

  @impl true
  def handle_info(:get_questions, socket),
    do: {:noreply, assign(socket, questions: Questions.get())}

  def handle_info({:new_question, question}, %{assigns: %{questions: questions}} = socket) do
    questions =
      (questions ++ [question])
      |> Enum.uniq_by(& &1.id)

    {:noreply, assign(socket, questions: questions)}
  end

  def handle_info({:new_quote, new_quote}, socket),
    do: {:noreply, assign(socket, quote: new_quote)}

  def handle_info(
        %{event: "presence_diff", payload: %{joins: _joins, leaves: _leaves}},
        socket
      ) do
    {:noreply, update_online_users(socket)}
  end

  defp create_question(body, name) do
    question = Questions.new(body, name)

    PubSub.broadcast!(@pub_sub_server, "questions", {:new_question, question})
    question
  end

  defp update_online_users(socket) do
    online_count = BoardPresence.list(@topic) |> map_size()

    online_users =
      @topic
      |> BoardPresence.list()
      |> Map.keys()
      |> Enum.sort()

    socket
    |> assign(:online_count, online_count)
    |> assign(:online_users, online_users)
  end
end
