defmodule RubyslavaElixir.Questions do
  @moduledoc """
  Storage for questions
  """
  use Agent

  alias RubyslavaElixir.Question

  def start_link(_) do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  def get do
    Agent.get(__MODULE__, & &1)
  end

  def store(%Question{} = question) do
    Agent.update(__MODULE__, &(&1 ++ [question]))
  end
end
