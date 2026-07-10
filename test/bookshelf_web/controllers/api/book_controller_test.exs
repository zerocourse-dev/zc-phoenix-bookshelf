defmodule BookshelfWeb.Api.BookControllerTest do
  use BookshelfWeb.ConnCase, async: true

  import Bookshelf.LibraryFixtures

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "GET /api/books" do
    test "lists all books", %{conn: conn} do
      book = book_fixture()

      conn = get(conn, ~p"/api/books")
      assert [%{"id" => id, "title" => _}] = json_response(conn, 200)["data"]
      assert id == book.id
    end

    test "honours filter params", %{conn: conn} do
      keep = book_fixture(status: "reading")
      _skip = book_fixture(status: "finished")

      conn = get(conn, ~p"/api/books?status=reading")
      assert [%{"id" => id}] = json_response(conn, 200)["data"]
      assert id == keep.id
    end
  end

  describe "GET /api/books/:id" do
    test "shows a book with its stats", %{conn: conn} do
      book = book_fixture()
      review_fixture(book, rating: 4)
      review_fixture(book, rating: 5)

      conn = get(conn, ~p"/api/books/#{book}")
      data = json_response(conn, 200)["data"]
      assert data["id"] == book.id
      assert data["stats"]["review_count"] == 2
      assert data["stats"]["average_rating"] == 4.5
    end

    test "returns 404 JSON for an unknown id", %{conn: conn} do
      conn = get(conn, ~p"/api/books/999999")
      assert json_response(conn, 404)
    end
  end

  describe "POST /api/books" do
    @valid %{
      title: "The Left Hand of Darkness",
      author: "Ursula K. Le Guin",
      isbn: "978-0441478125",
      year: 1969,
      status: "want_to_read"
    }

    test "creates a book and sets the Location header", %{conn: conn} do
      conn = post(conn, ~p"/api/books", book: @valid)

      assert %{"id" => id, "title" => "The Left Hand of Darkness"} =
               json_response(conn, 201)["data"]

      assert [location] = get_resp_header(conn, "location")
      assert location =~ "/api/books/#{id}"
    end

    test "renders a 422 errors map for invalid input", %{conn: conn} do
      conn = post(conn, ~p"/api/books", book: %{title: "", status: "burned"})
      errors = json_response(conn, 422)["errors"]
      assert %{"title" => [_ | _], "status" => [_ | _]} = errors
    end
  end

  describe "PUT /api/books/:id" do
    test "updates the book", %{conn: conn} do
      book = book_fixture()

      conn = put(conn, ~p"/api/books/#{book}", book: %{status: "finished"})
      assert json_response(conn, 200)["data"]["status"] == "finished"
    end

    test "renders 422 for an invalid update", %{conn: conn} do
      book = book_fixture()

      conn = put(conn, ~p"/api/books/#{book}", book: %{year: nil})
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "DELETE /api/books/:id" do
    test "deletes the book, then 404s on re-fetch", %{conn: conn} do
      book = book_fixture()

      conn = delete(conn, ~p"/api/books/#{book}")
      assert response(conn, 204)

      conn = get(conn, ~p"/api/books/#{book}")
      assert json_response(conn, 404)
    end
  end
end
