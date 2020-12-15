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
    tagging()
    slow()
    users = Accounts.list_users()
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
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
