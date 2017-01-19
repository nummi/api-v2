use Mix.Config

# For production, we configure the host to read the PORT
# from the system environment. Therefore, you will need
# to set PORT=80 before running your server.
#
# You should also configure the url host to something
# meaningful, we use this information when generating URLs.
#
# Finally, we also include the path to a manifest
# containing the digested version of static files. This
# manifest is generated by the mix phoenix.digest task
# which you typically run after static files are built.
config :canvas_api, CanvasAPI.Endpoint,
  http: [port: {:system, "PORT"}],
  instrumenters: [Appsignal.Phoenix.Instrumenter],
  url: [host: System.get_env("HOST"), port: 80],
  check_origin: ["https://pro.usecanvas.com"],
  pubsub: [name: CanvasAPI.PubSub,
           adapter: Phoenix.PubSub.Redis,
           url: System.get_env("REDIS_URL")],
  secret_key_base: System.get_env("SECRET_KEY_BASE")
  # force_ssl: [hsts: true]

# Do not print debug messages in production
config :logger, level: :info

# Configure your database
config :canvas_api, CanvasAPI.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: {:system, "DATABASE_URL"},
  loggers: [Appsignal.Ecto],
  pool_size: (System.get_env("DATABASE_POOL_SIZE") || "16") |> String.to_integer,
  ssl: true

# Configure Appsignal
config :appsignal, :config,
  name: :canvas_api,
  env: Mix.env,
  revision: System.get_env("HEROKU_SLUG_COMMIT")

# Configure Sentry
config :sentry,
  dsn: System.get_env("SENTRY_DSN"),
  environment_name: Mix.env,
  included_environments: [:prod],
  use_error_logger: true,
  release: System.get_env("HEROKU_SLUG_COMMIT")

# ## SSL Support
#
# To get SSL working, you will need to add the `https` key
# to the previous section and set your `:url` port to 443:
#
#     config :canvas_api, CanvasAPI.Endpoint,
#       ...
#       url: [host: "example.com", port: 443],
#       https: [port: 443,
#               keyfile: System.get_env("SOME_APP_SSL_KEY_PATH"),
#               certfile: System.get_env("SOME_APP_SSL_CERT_PATH")]
#
# Where those two env variables return an absolute path to
# the key and cert in disk or a relative path inside priv,
# for example "priv/ssl/server.key".
#
# We also recommend setting `force_ssl`, ensuring no data is
# ever sent via http, always redirecting to https:
#
#     config :canvas_api, CanvasAPI.Endpoint,
#       force_ssl: [hsts: true]
#
# Check `Plug.SSL` for all available options in `force_ssl`.

# ## Using releases
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start the server for all endpoints:
#
#     config :phoenix, :serve_endpoints, true
#
# Alternatively, you can configure exactly which server to
# start per endpoint:
#
#     config :canvas_api, CanvasAPI.Endpoint, server: true
#
