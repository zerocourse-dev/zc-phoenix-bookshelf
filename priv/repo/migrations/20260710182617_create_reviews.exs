defmodule Bookshelf.Repo.Migrations.CreateReviews do
  use Ecto.Migration

  def change do
    create table(:reviews) do
      add :rating, :integer, null: false
      add :body, :text, null: false
      add :reviewer, :string, null: false
      add :book_id, references(:books, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:reviews, [:book_id])
    create unique_index(:reviews, [:book_id, :reviewer])
  end
end
