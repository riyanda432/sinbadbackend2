defmodule MyAppWeb.UserController do
  use MyAppWeb, :controller

  alias MyApp.Auth
  alias MyApp.Auth.User
  alias MyApp.Repo

  action_fallback MyAppWeb.FallbackController

  def index(conn, _params) do
    users = Repo.all(User)
    render(conn, "index.json", users: users)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Repo.get!(User, id)
    changeset = Auth.User.changeset(user, user_params)
    case Repo.update(changeset) do
      {:ok, user} ->
        render(conn, "show.json", user: user)
      {:error, result} ->
        conn
        json conn |> put_status(:bad_request),
                     %{errors: ["update failed"]}
    end
  end

  def create(conn, %{"user" => user_params}) do
    changeset = Auth.User.changeset(%User{}, user_params)
    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> render("show.json", user: user)
        {:error, result} ->
          conn
          json conn |> put_status(:bad_request),
                       %{errors: ["email or name has been registered !"]}
    end
  end

  def show(conn, %{"id" => id}) do
    user = Auth.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def delete(conn, %{"id" => id}) do
    user = Auth.get_user!(id)

    with {:ok, %User{}} <- Auth.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
