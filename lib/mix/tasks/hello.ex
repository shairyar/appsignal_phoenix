defmodule Mix.Tasks.Hello do
  use Mix.Task

  @shortdoc "Simply calls the Hello.say/0 function."
  def run(_) do
    IO.puts("Hello, World!")

    # {:ok, _} = Application.ensure_all_started(:appsignal)
    # # calling our Hello.say() function from earlier
    # IO.puts("Hello, World!")
    # raise "rescue!"
    # catch
    # kind, reason ->
    #   stack = []
    #   Appsignal.send_error(kind, reason, stack)
    #   reraise(reason, stack)
    # after
    # Appsignal.Nif.stop
    # :timer.sleep(35_000) # For one-off containers
  end
end
