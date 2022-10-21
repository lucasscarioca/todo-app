defmodule TodoappWeb.TodoLive do
  use TodoappWeb, :live_view
  alias Todoapp.Todos

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, todo: "", todos: Todos.list_todos())}
  end

  @impl true
  def handle_event("submit_todo", %{"todo_input" => %{"todo" => todo, "done" => done}}, socket) do
    Todos.create_todo(%{todo: todo, done: done})
    {:noreply, assign(socket, todo: "")}
  end

  @impl true
  def handle_event("form_update", %{"todo_input" => %{"todo" => todo, "done" => _done}}, socket) do
    {:noreply, assign(socket, todo: todo)}
  end

  @impl true
  def handle_event("toggle_done", %{"id" => id}, socket) do
    todo = Todos.get_todo!(id)
    Todos.update_todo(todo, %{done: !todo.done})
    {:noreply, socket}
  end
end
