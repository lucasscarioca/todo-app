defmodule TodoappWeb.TodoLive do
  use TodoappWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, theme: "")}
  end
end
