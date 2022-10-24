defmodule TodoappWeb.TodoLive do
  use TodoappWeb, :live_view
  alias Todoapp.Todos

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       todo: "",
       todos: order_todos(Todos.list_todos()),
       todos_left: count_todos_left(),
       current_filter: "all"
     )}
  end

  @impl true
  def handle_event("submit_todo", %{"new_todo" => todo}, socket) do
    new_todo = Map.put(todo, "order", length(socket.assigns.todos))
    Todos.create_todo(new_todo)

    {:noreply,
     assign(socket,
       todo: "",
       todos: order_todos(Todos.list_todos()),
       todos_left: count_todos_left()
     )}
  end

  @impl true
  def handle_event("form_update", %{"new_todo" => %{"title" => todo, "done" => _done}}, socket) do
    {:noreply, assign(socket, todo: todo)}
  end

  @impl true
  def handle_event("toggle_done", %{"id" => id}, socket) do
    todo = Todos.get_todo!(id)
    Todos.update_todo(todo, %{done: !todo.done})

    {:noreply,
     assign(socket, todos: order_todos(Todos.list_todos()), todos_left: count_todos_left())}
  end

  @impl true
  def handle_event("delete_todo", %{"id" => id}, socket) do
    todo = Todos.get_todo!(id)
    Todos.delete_todo(todo)
    {:noreply, fetch(assign(socket, todos_left: count_todos_left()))}
  end

  @impl true
  def handle_event("filter_todos", %{"filter" => "all"}, socket) do
    {:noreply, fetch(assign(socket, current_filter: "all"))}
  end

  @impl true
  def handle_event("filter_todos", %{"filter" => filter}, socket) do
    case filter do
      "active" ->
        filtered_todos =
          Todos.list_todos()
          |> Enum.filter(fn todo -> todo.done === false end)

        {:noreply, assign(socket, todos: order_todos(filtered_todos), current_filter: "active")}

      "completed" ->
        filtered_todos =
          Todos.list_todos()
          |> Enum.filter(fn todo -> todo.done === true end)

        {:noreply,
         assign(socket, todos: order_todos(filtered_todos), current_filter: "completed")}

      _ ->
        {:error, socket}
    end
  end

  @impl true
  def handle_event("clear_completed", _, socket) do
    Todos.list_todos()
    |> Enum.filter(fn todo -> todo.done === true end)
    |> Enum.each(fn todo -> Todos.delete_todo(todo) end)

    {:noreply, fetch(assign(socket, todos_left: count_todos_left()))}
  end

  @impl true
  def handle_event("dropped", %{"draggedId" => todo_id, "draggableIndex" => list_index}, socket) do
    dragged_todo = Todos.get_todo!(todo_id)

    new_todos =
      socket.assigns.todos
      |> List.delete_at(dragged_todo.order)
      |> List.insert_at(list_index, dragged_todo)

    new_todos
    |> Enum.map(fn todo ->
      Todos.update_todo(todo, %{
        "order" => Enum.find_index(new_todos, fn x -> x.id == todo.id end)
      })
    end)

    {:noreply, fetch(socket)}
  end

  defp fetch(socket) do
    assign(socket, todos: order_todos(Todos.list_todos()))
  end

  defp count_todos_left() do
    lefts =
      Todos.list_todos()
      |> Enum.filter(fn todo -> todo.done == false end)

    length(lefts)
  end

  defp order_todos(todos) do
    Enum.sort_by(todos, &Map.fetch(&1, :order))
  end
end
