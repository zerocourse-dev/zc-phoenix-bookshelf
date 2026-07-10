defmodule BookshelfWeb.ActivityChannelTest do
  use BookshelfWeb.ChannelCase, async: false

  import Bookshelf.LibraryFixtures

  alias Bookshelf.Library

  defp join_lobby do
    BookshelfWeb.UserSocket
    |> socket("user", %{})
    |> subscribe_and_join(BookshelfWeb.ActivityChannel, "activity:lobby")
  end

  test "joining activity:lobby replies with the current book count" do
    book_fixture()
    book_fixture()

    assert {:ok, %{book_count: 2}, _socket} = join_lobby()
  end

  test "joining any other subtopic is rejected" do
    assert {:error, %{reason: "unauthorized"}} =
             BookshelfWeb.UserSocket
             |> socket("user", %{})
             |> subscribe_and_join(BookshelfWeb.ActivityChannel, "activity:vip")
  end

  test "ping replies with the payload" do
    {:ok, _, socket} = join_lobby()

    ref = push(socket, "ping", %{"hello" => "there"})
    assert_reply ref, :ok, %{"hello" => "there"}
  end

  test "a successful add_review pushes review_added to joined clients" do
    {:ok, _, _socket} = join_lobby()
    book = book_fixture()

    {:ok, _} = Library.add_review(book, %{rating: 5, body: "wow", reviewer: "zoe"})

    assert_push "review_added", payload
    assert payload.book_id == book.id
    assert payload.rating == 5
  end
end
