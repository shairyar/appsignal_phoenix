use Mix.Config

config :appsignal, :config,
  otp_app: :phoenix_demo,
  name: "phoenix_demo",
  push_api_key: "your-key",
  env: Mix.env
