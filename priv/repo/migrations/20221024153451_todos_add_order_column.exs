defmodule Todoapp.Repo.Migrations.TodosAddOrderColumn do
  use Ecto.Migration

  def change do
    alter table("todos") do
      add :order, :integer
    end
  end
end
