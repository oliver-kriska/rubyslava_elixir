defmodule RubyslavaElixir.Questions do
  @moduledoc """
  Storage for questions
  """
  use Agent

  alias RubyslavaElixir.Question

  @names ~w(Speedy Guy Raisin Pebbles Dilly Dally Sherlock Cheeto Dreamey Big Guy Heisenberg Gordo Fifi Flyby Jackrabbit Sleeping Beauty Friendo Shnookie Apple Dimples Lil Mama Pop Tart Hawk Frogger Beauty Ace Chef Mini Skirt Mini Me Cinnamon Ladybug Frauline Beanpole Ice Queen Swiss Miss Bunny Rabbit Baby Maker Loosetooth Weiner Hot Pepper Crumbles First Mate Shuttershy Chicken Legs Shrinkwrap Lover Cat Tiny Sport Sweet Sour Peppa Pig Brown Sugar Catwoman Fiesta Master Jet Bumblebee Cannoli Senior Frau Frau Drake Beast Papito Maestro Doobie String Bean Barbie Huggie Rabbit Halfling Snickers Dorito Birdy Betty Boop Cindy Lou Who Pretty Lady Big Bird Pixie Chum Butternut Popeye Fellow Dirt Buds Double Bubble Chica Janitor Mini Mini Dragonfly Rocketfuel Chico T-Dawg Freckles Loser Bossy Smiley Chip Bellbottoms Chump Angel Babs)

  def start_link(_) do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  def get, do: Agent.get(__MODULE__, & &1)

  def store(%Question{} = question) do
    Agent.update(__MODULE__, &(&1 ++ [question]))
  end

  def new(body, name) do
    question = %Question{
      id: :crypto.strong_rand_bytes(10) |> Base.encode16(),
      body: body,
      name: name,
      time: Timex.now()
    }

    store(question)

    question
  end

  def random_name do
    rand_number =
      length(@names)
      |> :rand.uniform()

    Enum.at(@names, rand_number, hd(@names))
  end
end
