import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :rubyslava_elixir, RubyslavaElixirWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "YD5QrWSFm7pdu9vVsSLD8BAsneyiiqkqaDWT9Lm8ePXLns95jpzt4SVbrjEbjZ/n",
  server: false

# In test we don't send emails.
config :rubyslava_elixir, RubyslavaElixir.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
