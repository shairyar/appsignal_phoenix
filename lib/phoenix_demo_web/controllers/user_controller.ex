defmodule PhoenixDemoWeb.UserController do
  use PhoenixDemoWeb, :controller

  alias PhoenixDemo.Accounts
  alias PhoenixDemo.Accounts.User

  plug :set_appsignal_namespace

  defp set_appsignal_namespace(conn, _params) do
    # Configures all actions in this controller to report
    # in the "user" namespace
    Appsignal.Span.set_namespace(Appsignal.Tracer.root_span, "user")
    conn
  end

  def index(conn, _params) do
    # tagging()
    # slow()

    try do
      raise "Exception! 2"
    catch
      kind, reason ->
        Appsignal.send_error(kind, reason, __STACKTRACE__, fn span ->
          Appsignal.Span.set_sample_data(
          Appsignal.Tracer.root_span,
          "custom_data",
          %{
            i18n: %{
              locale: "en_GB",
              default_locale: "en_US"
            }
          }
        )
        end)
    end


    users = Accounts.list_users()
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    Appsignal.Span.set_sample_data(Appsignal.Tracer.root_span, "tags", %{tag1: "value1", tag2: "value2"})
    Appsignal.increment_counter("user_created", 1)
    Appsignal.increment_counter("random_name", 1, %{tag1: "value1", tag2: "value2"})
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: Routes.user_path(conn, :show, user))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do

          # Appsignal.Span.set_sample_data(
          # Appsignal.Tracer.root_span,
          # "custom_data",
          # %{key_1: "BBBBB", key_2: "CCCCCC"} # to be replaced by payload
          # )
          raise "Exception 2-1!"
    # try do
    #   raise "Exception 2-1!"

    # catch
    #   kind, reason ->
    #   Appsignal.Span.set_sample_data(
    #   Appsignal.Tracer.root_span(),
    #   "custom_data",
    #   %{key_1: "BBBBB_set_error", key_2: "CCCCCC"} # to be replaced by payload
    #   )
    #   Appsignal.set_error(kind, reason, __STACKTRACE__)

    # end



    Appsignal.set_gauge("Views", 100, %{tag_a: "a", tag_b: "b"})
    user = Accounts.get_user!(id)
    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    changeset = Accounts.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    case Accounts.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    {:ok, _user} = Accounts.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: Routes.user_path(conn, :index))
  end

  defp tagging do

    # Adding tags example (https://docs.appsignal.com/elixir/instrumentation/tagging.html#tags)
    Appsignal.Span.set_sample_data(Appsignal.Tracer.root_span, "tags", %{locale: "en"})

    # Adding sample data example (https://docs.appsignal.com/elixir/instrumentation/tagging.html#sample-data)
    Appsignal.Span.set_sample_data(Appsignal.Tracer.root_span, "custom_data", %{foo: "bar"})


  end

  defp slow do

    # Adding spans to traces (https://docs.appsignal.com/elixir/instrumentation/instrumentation.html#add-spans-to-traces)
    Appsignal.instrument("slow", fn ->
      :timer.sleep(1000)
    end)
  end

end
