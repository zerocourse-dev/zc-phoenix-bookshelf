defmodule Bookshelf.Library do
  @moduledoc """
  The Library context.
  """

  import Ecto.Query, warn: false
  alias Bookshelf.Repo

  alias Bookshelf.Library.Book

  @doc """
  Returns the list of books, filtered and sorted. GRADED.

  Supported filters (combinable — all that are present must apply):

    * `status: "reading"` — exact match on status
    * `author: "le guin"` — case-insensitive substring match on author
    * `year_from: 1990` / `year_to: 2000` — inclusive publication-year range
    * `sort: :title` (A→Z), `sort: :year_desc` (newest first),
      `sort: :recent` (most recently inserted first — the default)

  Build ONE query with composable `from`/`where` clauses — no filtering
  in Elixir after `Repo.all/1`. The tests seed enough rows to catch it.

  ## Examples

      iex> list_books(status: "reading", sort: :title)
      [%Book{}, ...]

  """
  def list_books(filters \\ []) do
    _ = filters

    raise "NotImplementedError: implement list_books/1"
  end

  @doc """
  Gets a single book.

  Raises `Ecto.NoResultsError` if the Book does not exist.

  ## Examples

      iex> get_book!(123)
      %Book{}

      iex> get_book!(456)
      ** (Ecto.NoResultsError)

  """
  def get_book!(id), do: Repo.get!(Book, id)

  @doc """
  Gets a single book, or `nil` when it does not exist — pair it with
  `{:error, :not_found}` and the FallbackController in API actions
  instead of letting `get_book!/1` raise.
  """
  def get_book(id), do: Repo.get(Book, id)

  @doc """
  Creates a book.

  ## Examples

      iex> create_book(%{field: value})
      {:ok, %Book{}}

      iex> create_book(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_book(attrs) do
    %Book{}
    |> Book.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a book.

  ## Examples

      iex> update_book(book, %{field: new_value})
      {:ok, %Book{}}

      iex> update_book(book, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_book(%Book{} = book, attrs) do
    book
    |> Book.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a book.

  ## Examples

      iex> delete_book(book)
      {:ok, %Book{}}

      iex> delete_book(book)
      {:error, %Ecto.Changeset{}}

  """
  def delete_book(%Book{} = book) do
    Repo.delete(book)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking book changes.

  ## Examples

      iex> change_book(book)
      %Ecto.Changeset{data: %Book{}}

  """
  def change_book(%Book{} = book, attrs \\ %{}) do
    Book.changeset(book, attrs)
  end

  alias Bookshelf.Library.Review

  @doc """
  Returns the list of reviews.

  ## Examples

      iex> list_reviews()
      [%Review{}, ...]

  """
  def list_reviews do
    Repo.all(Review)
  end

  @doc """
  Gets a single review.

  Raises `Ecto.NoResultsError` if the Review does not exist.

  ## Examples

      iex> get_review!(123)
      %Review{}

      iex> get_review!(456)
      ** (Ecto.NoResultsError)

  """
  def get_review!(id), do: Repo.get!(Review, id)

  @doc """
  Creates a review.

  ## Examples

      iex> create_review(%{field: value})
      {:ok, %Review{}}

      iex> create_review(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_review(attrs) do
    %Review{}
    |> Review.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a review.

  ## Examples

      iex> update_review(review, %{field: new_value})
      {:ok, %Review{}}

      iex> update_review(review, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_review(%Review{} = review, attrs) do
    review
    |> Review.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a review.

  ## Examples

      iex> delete_review(review)
      {:ok, %Review{}}

      iex> delete_review(review)
      {:error, %Ecto.Changeset{}}

  """
  def delete_review(%Review{} = review) do
    Repo.delete(review)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking review changes.

  ## Examples

      iex> change_review(review)
      %Ecto.Changeset{data: %Review{}}

  """
  def change_review(%Review{} = review, attrs \\ %{}) do
    Review.changeset(review, attrs)
  end

  @doc """
  Adds a review to a book. GRADED.

  On success returns `{:ok, %Review{}}` AND broadcasts the event
  `"review_added"` on the `"activity:lobby"` channel topic with payload
  `%{book_id: ..., reviewer: ..., rating: ...}` (see
  `BookshelfWeb.Endpoint.broadcast/3`). Returns `{:error, changeset}`
  for invalid input — including a rating outside 1..5 and a second
  review by the same reviewer on the same book (the unique index must
  surface as a changeset error, not an exception).
  """
  def add_review(%Book{} = book, attrs) do
    _ = {book, attrs}

    raise "NotImplementedError: implement add_review/2"
  end

  @doc """
  Aggregate stats for a book, computed in the DATABASE. GRADED.

  Returns `%{review_count: non_neg_integer, average_rating: float | nil}`
  — `average_rating` rounded to 1 decimal place, `nil` when the book has
  no reviews. One query (`Ecto.Query.API.avg/1` + `count/1`), not
  `Repo.all` + Elixir math.
  """
  def book_stats(%Book{} = book) do
    _ = book

    raise "NotImplementedError: implement book_stats/1"
  end
end
