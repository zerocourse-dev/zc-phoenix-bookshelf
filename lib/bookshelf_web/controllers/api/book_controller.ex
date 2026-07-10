defmodule BookshelfWeb.Api.BookController do
  use BookshelfWeb, :controller

  @moduledoc """
  The JSON API. GRADED.

  Every action goes through `Bookshelf.Library` and leans on
  `BookshelfWeb.FallbackController` for the error paths (`action_fallback`
  is already wired). The `with {:ok, book} <- ...` pattern plus the
  fallback is the Phoenix idiom for "happy path here, errors rendered
  uniformly over there" — the tests pin the exact JSON shapes:

    * `GET /api/books` — 200, `%{"data" => [...]}`, honours the same
      filter params as `Library.list_books/1` (`status`, `author`,
      `year_from`, `year_to`)
    * `GET /api/books/:id` — 200 with the book, including `"stats"` from
      `Library.book_stats/1`; unknown id → 404 JSON (use `Library.get_book/1`
      and return `{:error, :not_found}` — never let `get_book!/1` raise
      for API control flow)
    * `POST /api/books` — 201 + Location header; invalid → 422 with
      `%{"errors" => %{field => [messages]}}`
    * `PUT /api/books/:id` — 200; invalid → 422
    * `DELETE /api/books/:id` — 204, empty body
  """

  action_fallback BookshelfWeb.FallbackController

  def index(conn, params) do
    _ = {conn, params}

    raise "NotImplementedError: implement index/2"
  end

  def create(conn, params) do
    _ = {conn, params}

    raise "NotImplementedError: implement create/2"
  end

  def show(conn, params) do
    _ = {conn, params}

    raise "NotImplementedError: implement show/2"
  end

  def update(conn, params) do
    _ = {conn, params}

    raise "NotImplementedError: implement update/2"
  end

  def delete(conn, params) do
    _ = {conn, params}

    raise "NotImplementedError: implement delete/2"
  end
end
