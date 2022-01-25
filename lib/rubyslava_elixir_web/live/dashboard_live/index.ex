defmodule RubyslavaElixirWeb.DashboardLive.Index do
  @moduledoc """
  Simple LiveView implementation
  """
  use RubyslavaElixirWeb, :live_view

  alias Phoenix.PubSub
  alias RubyslavaElixir.{Question, Questions}

  @pub_sub_server RubyslavaElixir.PubSub

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Process.send_after(self(), :get_questions, 1)
      Phoenix.PubSub.subscribe(@pub_sub_server, "questions")
    end

    socket =
      socket
      |> assign(:questions, [])

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

  defp create_question(body) do
    question = %Question{
      id: :crypto.strong_rand_bytes(10) |> Base.encode16(),
      body: body,
      time: Timex.now()
    }

    Questions.store(question)
    PubSub.broadcast!(@pub_sub_server, "questions", {:new_question, question})
    question
  end
end
