defmodule TodoappWeb.TodoLive do
  use TodoappWeb, :live_view
  alias Todoapp.Todos

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, todo: "", todos: Todos.list_todos())}
  end

  @impl true
  def handle_event("submit_todo", %{"new_todo" => todo}, socket) do
    Todos.create_todo(todo)
    {:noreply, assign(socket, todo: "", todos: Todos.list_todos())}
  end

  @impl true
  def handle_event("form_update", %{"new_todo" => %{"title" => todo, "done" => _done}}, socket) do
    {:noreply, assign(socket, todo: todo)}
  end

  @impl true
  def handle_event("toggle_done", %{"id" => id}, socket) do
    todo = Todos.get_todo!(id)
    Todos.update_todo(todo, %{done: !todo.done})
    {:noreply, socket}
  end
end
