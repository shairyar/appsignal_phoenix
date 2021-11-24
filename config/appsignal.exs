use Mix.Config

config :appsignal, :config,
  otp_app: :phoenix_demo,
  name: "phoenix_demo",
  debug: true,
  transaction_debug_mode: true,
  log_path: "logs",
  env: Mix.env,
  filter_parameters: ["user_created"]
