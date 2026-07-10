defmodule Bookshelf.LibraryTest do
  use Bookshelf.DataCase, async: true

  import Bookshelf.LibraryFixtures

  alias Bookshelf.Library

  describe "list_books/1 — filtering" do
    setup do
      %{
        earthsea:
          book_fixture(
            title: "A Wizard of Earthsea",
            author: "Ursula K. Le Guin",
            year: 1968,
            status: "finished"
          ),
        dispossessed:
          book_fixture(
            title: "The Dispossessed",
            author: "Ursula K. Le Guin",
            year: 1974,
            status: "reading"
          ),
        pragprog:
          book_fixture(
            title: "The Pragmatic Programmer",
            author: "Hunt & Thomas",
            year: 1999,
            status: "finished"
          ),
        designing:
          book_fixture(
            title: "Designing Data-Intensive Applications",
            author: "Martin Kleppmann",
            year: 2017,
            status: "want_to_read"
          )
      }
    end

    test "no filters returns every book", %{earthsea: e, dispossessed: d, pragprog: p, designing: dd} do
      ids = Library.list_books() |> Enum.map(& &1.id) |> Enum.sort()
      assert ids == Enum.sort([e.id, d.id, p.id, dd.id])
    end

    test "filters by exact status", %{earthsea: e, pragprog: p} do
      ids = Library.list_books(status: "finished") |> Enum.map(& &1.id) |> Enum.sort()
      assert ids == Enum.sort([e.id, p.id])
    end

    test "filters by author substring, case-insensitively", %{earthsea: e, dispossessed: d} do
      ids = Library.list_books(author: "le guin") |> Enum.map(& &1.id) |> Enum.sort()
      assert ids == Enum.sort([e.id, d.id])
    end

    test "filters by inclusive year range", %{dispossessed: d, pragprog: p} do
      ids = Library.list_books(year_from: 1974, year_to: 1999) |> Enum.map(& &1.id) |> Enum.sort()
      assert ids == Enum.sort([d.id, p.id])
    end

    test "combines status, author, and year filters", %{earthsea: e} do
      assert [%{id: id}] = Library.list_books(status: "finished", author: "guin", year_to: 1970)
      assert id == e.id
    end

    test "sort: :title orders A to Z" do
      titles = Library.list_books(sort: :title) |> Enum.map(& &1.title)
      assert titles == Enum.sort(titles)
      assert length(titles) == 4
    end

    test "sort: :year_desc orders newest first" do
      years = Library.list_books(sort: :year_desc) |> Enum.map(& &1.year)
      assert years == Enum.sort(years, :desc)
      assert length(years) == 4
    end
  end

  describe "add_review/2" do
    setup do
      %{book: book_fixture()}
    end

    test "creates a review with valid attrs", %{book: book} do
      assert {:ok, review} =
               Library.add_review(book, %{rating: 4, body: "Solid.", reviewer: "alice"})

      assert review.book_id == book.id
      assert review.rating == 4
    end

    test "broadcasts review_added on activity:lobby", %{book: book} do
      BookshelfWeb.Endpoint.subscribe("activity:lobby")

      {:ok, _} = Library.add_review(book, %{rating: 5, body: "!", reviewer: "bob"})

      assert_receive %Phoenix.Socket.Broadcast{event: "review_added", payload: payload}
      assert payload.book_id == book.id
      assert payload.reviewer == "bob"
      assert payload.rating == 5
    end

    test "rejects a rating outside 1..5", %{book: book} do
      assert {:error, changeset} =
               Library.add_review(book, %{rating: 6, body: "x", reviewer: "carol"})

      assert %{rating: _} = errors_on(changeset)

      assert {:error, _} = Library.add_review(book, %{rating: 0, body: "x", reviewer: "carol"})
    end

    test "rejects missing fields", %{book: book} do
      assert {:error, changeset} = Library.add_review(book, %{})
      errors = errors_on(changeset)
      assert Map.has_key?(errors, :rating)
      assert Map.has_key?(errors, :body)
      assert Map.has_key?(errors, :reviewer)
    end

    test "a second review by the same reviewer is a changeset error, not a crash", %{book: book} do
      attrs = %{rating: 3, body: "first", reviewer: "dave"}
      assert {:ok, _} = Library.add_review(book, attrs)
      assert {:error, changeset} = Library.add_review(book, %{attrs | body: "second"})
      assert %{reviewer: _} = errors_on(changeset)
    end

    test "the same reviewer may review a different book", %{book: book} do
      other = book_fixture()
      attrs = %{rating: 3, body: "fine", reviewer: "erin"}
      assert {:ok, _} = Library.add_review(book, attrs)
      assert {:ok, _} = Library.add_review(other, attrs)
    end
  end

  describe "book_stats/1" do
    test "averages ratings and counts reviews" do
      book = book_fixture()
      review_fixture(book, rating: 5)
      review_fixture(book, rating: 4)
      review_fixture(book, rating: 4)

      assert %{review_count: 3, average_rating: 4.3} = Library.book_stats(book)
    end

    test "returns nil average and zero count for an unreviewed book" do
      book = book_fixture()
      assert %{review_count: 0, average_rating: nil} = Library.book_stats(book)
    end

    test "only counts the given book's reviews" do
      book = book_fixture()
      other = book_fixture()
      review_fixture(book, rating: 2)
      review_fixture(other, rating: 5)

      assert %{review_count: 1, average_rating: 2.0} = Library.book_stats(book)
    end
  end
end
