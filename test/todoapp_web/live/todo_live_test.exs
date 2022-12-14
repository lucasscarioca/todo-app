defmodule TodoappWeb.TodoLiveTest do
  use TodoappWeb.ConnCase
  import Phoenix.LiveViewTest

  test "connected mount", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")
    assert has_element?(view, "h1", "TODO")
  end

  test "User should be able to add a new todo", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")

    view
    |> form("#todo-form", new_todo: %{title: "test todo"})
    |> render_submit()

    assert has_element?(view, "li", "test todo")
  end

  test "User should be able to mark a todo as completed", %{conn: conn} do
    {:ok, todo} = Todoapp.Todos.create_todo(%{done: false, title: "test todo", order: 0})
    {:ok, view, _html} = live(conn, "/")

    view
    |> element("#todo_#{todo.id}")
    |> render_click()

    updated_todo = Todoapp.Todos.get_todo!(todo.id)

    assert has_element?(view, "#todo_#{todo.id}:checked")
    assert updated_todo.done
  end

  test "User should be able to delete a todo", %{conn: conn} do
    {:ok, todo} = Todoapp.Todos.create_todo(%{done: false, title: "test todo", order: 0})
    {:ok, view, _html} = live(conn, "/")

    view
    |> element("#delbtn_#{todo.id}")
    |> render_click()

    refute has_element?(view, "#delbtn_#{todo.id}")
  end

  test "User should be able to clear all completed todos", %{conn: conn} do
    {:ok, todo} = Todoapp.Todos.create_todo(%{done: true, title: "test todo", order: 0})
    {:ok, view, _html} = live(conn, "/")

    view
    |> element("#clear-completed")
    |> render_click()

    refute has_element?(view, "li", todo.title)
  end
end
