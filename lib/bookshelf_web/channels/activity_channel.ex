defmodule BookshelfWeb.ActivityChannel do
  use BookshelfWeb, :channel

  @moduledoc """
  The live activity feed. GRADED.

  Clients join `"activity:lobby"` and from then on receive a
  `"review_added"` push every time `Bookshelf.Library.add_review/2`
  succeeds anywhere in the app — that is the whole real-time feature.
  """

  @doc """
  Join `"activity:lobby"`. GRADED.

  Reply `{:ok, %{book_count: n}, socket}` where `n` is the current
  number of books (a cheap `Repo.aggregate/2` — the client uses it to
  render its header before any event arrives). Reject any other
  subtopic with `{:error, %{reason: "unauthorized"}}`.
  """
  @impl true
  def join(topic, payload, socket) do
    _ = {topic, payload, socket}

    raise "NotImplementedError: implement join/3"
  end

  @doc """
  Handle `"ping"` by replying `{:ok, payload}` — the connectivity check
  the test client uses. GRADED.
  """
  @impl true
  def handle_in("ping", payload, socket) do
    _ = {payload, socket}

    raise "NotImplementedError: implement handle_in(\"ping\", ...)"
  end
end
