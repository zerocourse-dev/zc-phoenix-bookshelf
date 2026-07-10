defmodule Bookshelf.Repo.Migrations.CreateBooks do
  use Ecto.Migration

  def change do
    create table(:books) do
      add :title, :string
      add :author, :string
      add :isbn, :string
      add :year, :integer
      add :status, :string

      timestamps(type: :utc_datetime)
    end

    create unique_index(:books, [:isbn])
  end
end
