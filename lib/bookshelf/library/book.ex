defmodule Bookshelf.Library.Book do
  use Ecto.Schema
  import Ecto.Changeset

  schema "books" do
    field :title, :string
    field :author, :string
    field :isbn, :string
    field :year, :integer
    field :status, :string

    has_many :reviews, Bookshelf.Library.Review

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(book, attrs) do
    book
    |> cast(attrs, [:title, :author, :isbn, :year, :status])
    |> validate_required([:title, :author, :isbn, :year, :status])
    |> validate_inclusion(:status, ~w(want_to_read reading finished))
    |> unique_constraint(:isbn)
  end
end
