defmodule BookshelfWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use BookshelfWeb, :controller

  # Invalid changesets render as 422 with an errors map — see ChangesetJSON.
  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(json: BookshelfWeb.ChangesetJSON)
    |> render(:error, changeset: changeset)
  end

  # This clause handles resources that cannot be found.
  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(html: BookshelfWeb.ErrorHTML, json: BookshelfWeb.ErrorJSON)
    |> render(:"404")
  end
end
