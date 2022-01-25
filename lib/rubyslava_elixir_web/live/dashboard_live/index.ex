defmodule RubyslavaElixirWeb.DashboardLive.Index do
  @moduledoc """
  Simple LiveView implementation
  """
  use RubyslavaElixirWeb, :live_view

  alias Phoenix.PubSub
  alias RubyslavaElixir.Questions

  @pub_sub_server RubyslavaElixir.PubSub

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Process.send_after(self(), :get_questions, 1)
      Phoenix.PubSub.subscribe(@pub_sub_server, "questions")
      Phoenix.PubSub.subscribe(@pub_sub_server, "quotes")
    end

    socket =
      socket
      |> assign(:questions, [])
      |> assign(:quote, nil)

    {:ok, socket}
  end

  @impl true
  def handle_event("ask", %{"question" => body}, %{assigns: %{questions: questions}} = socket) do
    question = create_question(body)
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

  defp create_question(body) do
    question = Questions.new(body)

    PubSub.broadcast!(@pub_sub_server, "questions", {:new_question, question})
    question
  end
end
