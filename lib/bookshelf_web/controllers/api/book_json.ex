defmodule BookshelfWeb.Api.BookJSON do
  alias Bookshelf.Library.Book

  @doc """
  Renders a list of books.
  """
  def index(%{books: books}) do
    %{data: for(book <- books, do: data(book))}
  end

  @doc """
  Renders a single book. Pass `stats:` (from `Library.book_stats/1`)
  and it is embedded under `"stats"` — the show action does this.
  """
  def show(%{book: book, stats: stats}) do
    %{data: Map.put(data(book), :stats, stats)}
  end

  def show(%{book: book}) do
    %{data: data(book)}
  end

  defp data(%Book{} = book) do
    %{
      id: book.id,
      title: book.title,
      author: book.author,
      isbn: book.isbn,
      year: book.year,
      status: book.status
    }
  end
end
