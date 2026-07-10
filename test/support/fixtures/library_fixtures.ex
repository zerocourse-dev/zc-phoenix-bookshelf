defmodule Bookshelf.LibraryFixtures do
  @moduledoc """
  Test helpers for creating Library entities.

  These insert through `Repo` directly, NOT through the functions you are
  implementing — so a broken `add_review/2` can never break the fixtures
  that its own tests depend on. Don't edit this file.
  """

  alias Bookshelf.Repo
  alias Bookshelf.Library.{Book, Review}

  def unique_book_isbn, do: "978-#{System.unique_integer([:positive])}"

  def book_fixture(attrs \\ %{}) do
    defaults = %{
      author: "Ursula K. Le Guin",
      isbn: unique_book_isbn(),
      status: "want_to_read",
      title: "A Wizard of Earthsea",
      year: 1968
    }

    struct!(Book, Map.merge(defaults, Map.new(attrs)))
    |> Repo.insert!()
  end

  def review_fixture(%Book{} = book, attrs \\ %{}) do
    defaults = %{
      body: "Sparse, precise, and wise.",
      rating: 5,
      reviewer: "reader-#{System.unique_integer([:positive])}",
      book_id: book.id
    }

    struct!(Review, Map.merge(defaults, Map.new(attrs)))
    |> Repo.insert!()
  end
end
