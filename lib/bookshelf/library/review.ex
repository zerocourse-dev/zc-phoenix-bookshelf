defmodule Bookshelf.Library.Review do
  use Ecto.Schema
  import Ecto.Changeset

  schema "reviews" do
    field :rating, :integer
    field :body, :string
    field :reviewer, :string

    belongs_to :book, Bookshelf.Library.Book

    timestamps(type: :utc_datetime)
  end

  @doc """
  TODO(you): this changeset is naive. The tests expect it to also

    * reject ratings outside 1..5
    * turn the (book_id, reviewer) unique index violation into a
      changeset error on :reviewer instead of a raised exception

  See `Ecto.Changeset.validate_inclusion/3` and
  `Ecto.Changeset.unique_constraint/3`.
  """
  def changeset(review, attrs) do
    review
    |> cast(attrs, [:rating, :body, :reviewer])
    |> validate_required([:rating, :body, :reviewer])
  end
end
