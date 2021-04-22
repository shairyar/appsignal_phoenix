use Mix.Config

{revision, _exitcode} = System.cmd("git", ["log", "--pretty=format:%h", "-n 1"])
config :appsignal, :config,
  revision: revision,
  otp_app: :phoenix_demo,
  name: "phoenix_demo",
  push_api_key: "a1d7abab-dcbf-464b-a546-bb535e6ec73c",
  debug: true,
  transaction_debug_mode: true,
  env: Mix.env
