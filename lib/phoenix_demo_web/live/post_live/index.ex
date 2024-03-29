defmodule PhoenixDemoWeb.PostLive.Index do
  use PhoenixDemoWeb, :live_view
  use Phoenix.LiveView
  import Appsignal.Phoenix.LiveView, only: [live_view_action: 4]

  alias PhoenixDemo.Timeline
  alias PhoenixDemo.Timeline.Post

  @impl true
  def mount(_params, _session, socket) do
    live_view_action(__MODULE__, "mount", socket, fn ->
      Appsignal.Span.set_sample_data(Appsignal.Tracer.root_span, "custom_data", %{
        name: "John Doe"
      })
      if connected?(socket), do: Timeline.subscribe()
      {:ok, assign(socket, :posts, fetch_posts()), temporary_assigns: [posts: []]}
    end)
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Post")
    |> assign(:post, Timeline.get_post!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Post")
    |> assign(:post, %Post{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Posts")
    |> assign(:post, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    post = Timeline.get_post!(id)
    {:ok, _} = Timeline.delete_post(post)

    {:noreply, assign(socket, :posts, list_posts())}
  end

  defp list_posts do
    Timeline.list_posts()
  end

  @impl true
  def handle_info({:post_created, post}, socket) do
    live_view_action(__MODULE__, "post_created", socket, fn ->
      {:noreply, update(socket, :posts, fn posts -> [post | posts] end)}
    end)
  end

  def handle_info({:post_updated, post}, socket) do
    live_view_action(__MODULE__, "post_updated", socket, fn ->
      {:noreply, update(socket, :posts, fn posts -> [post | posts] end)}
    end)
  end

  defp fetch_posts do
    raise 'oops'
    Timeline.list_posts()
  end
end
